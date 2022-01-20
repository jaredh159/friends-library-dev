import Foundation
import NonEmpty
import TaggedMoney

enum PrintJobServiceError: Error {
  case noExploratoryMetadataRetrieved
  case invalidMoneyStringFromApi(String)
  case invalidInputForCreditCardFeeOffset
}

enum PrintJobService {
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

  static func creditCardFeeOffset(_ desiredNet: Cents<Int>) throws -> Cents<Int> {
    if desiredNet <= 0 {
      throw PrintJobServiceError.invalidInputForCreditCardFeeOffset
    }
    let withFlatFee = desiredNet.rawValue + STRIPE_FLAT_FEE
    let percentageOffset = calculatePercentageOffset(withFlatFee)
    return .init(rawValue: STRIPE_FLAT_FEE + percentageOffset)
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
        throw PrintJobServiceError.noExploratoryMetadataRetrieved
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
}

private func toCents(_ string: String) throws -> Cents<Int> {
  guard let dollars = Double(string) else {
    throw PrintJobServiceError.invalidMoneyStringFromApi(string)
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
