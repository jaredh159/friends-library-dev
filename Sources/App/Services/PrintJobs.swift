import Foundation
import NonEmpty
import TaggedMoney

enum PrintJobs {

  static func create(_ order: Order) async throws -> Lulu.Api.PrintJob {
    let orderItems: [OrderItem]
    if case .loaded(let items) = order.items {
      orderItems = items
    } else {
      orderItems = try await Current.db.query(OrderItem.self)
        .where(.orderId == order.id)
        .all()
      order.items = .loaded(orderItems)
    }

    for item in orderItems {
      item.order = .loaded(order)
      if case .notLoaded = item.edition {
        let edition = try await Current.db.find(item.editionId)
        item.edition = .loaded(edition)
      }
    }

    let lineItems = try orderItems.flatMap { item -> [Lulu.Api.CreatePrintJobBody.LineItem] in
      let edition = item.edition.require()
      guard let impression = edition.impression.require() else {
        throw Error.unexpectedMissingEditionImpression(order.id, edition.id)
      }
      return impression.paperbackVolumes.enumerated().map { index, pages in
        let titleSuffix = impression.paperbackVolumes.count > 1 ? ", vol. \(index + 1)" : ""
        return .init(
          title: edition.document.require().title + titleSuffix,
          cover: impression.files.paperbackCover[index].url.absoluteString,
          interior: impression.files.paperbackInterior[index].url.absoluteString,
          podPackageId: Lulu.podPackageId(size: impression.paperbackSize.printSize, pages: pages),
          quantity: item.quantity
        )
      }
    }

    let payload = Lulu.Api.CreatePrintJobBody(
      shippingLevel: order.shippingLevel.lulu,
      shippingAddress: order.address.lulu,
      contactEmail: "jared@netrivet.com",
      externalId: order.id.rawValue.uuidString,
      lineItems: lineItems
    )
    return try await Current.luluClient.createPrintJob(payload)
  }

  struct ExploratoryItem {
    let volumes: NonEmpty<[Int]>
    let printSize: PrintSize
    let quantity: Int
  }

  struct ExploratoryMetadata {
    let shippingLevel: Order.ShippingLevel
    let shipping: Cents<Int>
    let taxes: Cents<Int>
    let fees: Cents<Int>
    let creditCardFeeOffset: Cents<Int>
  }

  static func getExploratoryMetadata(
    for items: [ExploratoryItem],
    shippedTo address: ShippingAddress
  ) async throws -> ExploratoryMetadata {
    try await withThrowingTaskGroup(of: (
      Lulu.Api.PrintJobCostCalculationResponse?,
      Order.ShippingLevel
    ).self) { group -> ExploratoryMetadata in
      for level in Order.ShippingLevel.allCases {
        group.addTask {
          (
            try? await Current.luluClient.createPrintJobCostCalculation(
              address.lulu,
              level.lulu,
              items.flatMap { item in
                item.volumes.map { pages in
                  .init(
                    pageCount: pages,
                    podPackageId: Lulu.podPackageId(size: item.printSize, pages: pages),
                    quantity: item.quantity
                  )
                }
              }
            ),
            level
          )
        }
      }

      var results: [(Lulu.Api.PrintJobCostCalculationResponse, Order.ShippingLevel)] = []
      for try await (res, level) in group {
        if let res = res {
          results.append((res, level))
        }
      }

      results.sort { a, b in a.0.totalCostInclTax < b.0.totalCostInclTax }
      guard let (cheapest, level) = results.first else {
        throw Error.noExploratoryMetadataRetrieved
      }

      return try ExploratoryMetadata(
        shippingLevel: level,
        shipping: toCents(cheapest.shippingCost.totalCostExclTax),
        taxes: toCents(cheapest.totalTax),
        fees: cheapest.fees
          .reduce(Cents<Int>(rawValue: 0)) { sum, fee in
            sum + (try toCents(fee.totalCostExclTax))
          },
        creditCardFeeOffset: creditCardFeeOffset(toCents(cheapest.totalCostInclTax))
      )
    }
  }

  static func creditCardFeeOffset(_ desiredNet: Cents<Int>) throws -> Cents<Int> {
    if desiredNet <= 0 {
      throw Error.invalidInputForCreditCardFeeOffset
    }
    let withFlatFee = desiredNet.rawValue + STRIPE_FLAT_FEE
    let percentageOffset = calculatePercentageOffset(withFlatFee)
    return .init(rawValue: STRIPE_FLAT_FEE + percentageOffset)
  }

  enum Error: Swift.Error, LocalizedError {
    case noExploratoryMetadataRetrieved
    case invalidMoneyStringFromApi(String)
    case invalidInputForCreditCardFeeOffset
    case unexpectedMissingEditionImpression(Order.Id, Edition.Id)

    var errorDescription: String? {
      switch self {
        case .noExploratoryMetadataRetrieved:
          return "No exploratory metadata could be retrieved. Very likely shipping was not possible."
        case .invalidMoneyStringFromApi(let value):
          return "Could not convert API currency string value (\(value)) to cents."
        case .invalidInputForCreditCardFeeOffset:
          return "Invalid negative or zero amount for calculating credit card offset."
        case .unexpectedMissingEditionImpression(let orderId, let editionId):
          return "Unexpected missing edition impression for edition \(editionId) in order \(orderId)."
      }
    }
  }
}

// helpers

private func toCents(_ string: String) throws -> Cents<Int> {
  guard let dollars = Double(string) else {
    throw PrintJobs.Error.invalidMoneyStringFromApi(string)
  }
  return .init(rawValue: Int(dollars * 100))
}

private let STRIPE_FLAT_FEE = 30
private let STRIPE_PERCENTAGE = 0.029

private func calculatePercentageOffset(_ amount: Int, _ carry: Int = 0) -> Int {
  let offset = (Double(amount) * STRIPE_PERCENTAGE).rounded(.toNearestOrAwayFromZero)
  if offset == 0.0 {
    return carry
  }
  return calculatePercentageOffset(Int(offset), carry + Int(offset))
}
