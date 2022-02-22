import Foundation
import GraphQL
import XCTest
import XCTVaporUtils

@testable import App

final class PrintJobsTests: AppTestCase {

  func testQueryExploratoryMetadata() async throws {
    let responses = Responses([
      .init(shipping: "9.99", tax: "3.33", total: "19.12", fee: "1.50"),
      .init(shipping: "10.99", tax: "4.33", total: "20.12", fee: "1.50"),
    ])

    Current.luluClient.createPrintJobCostCalculation = { _, _, _ in
      await responses.next()
    }

    let input: Map = .dictionary([
      "items": .array([
        .dictionary([
          "volumes": .array([55]),
          "printSize": "m",
          "quantity": 1,
        ]),
      ]),
      "address": ShippingAddress.mock.gqlMap(),
    ])

    GraphQLTest(
      """
      query GetPrintJobExploratoryMetadata($input: GetPrintJobExploratoryMetadataInput!) {
        getPrintJobExploratoryMetadata(input: $input) {
          shippingInCents
          taxesInCents
          feesInCents
          creditCardFeeOffsetInCents
        }
      }
      """,
      expectedData: .containsKVPs([
        "shippingInCents": 999,
        "taxesInCents": 333,
        "feesInCents": 150,
        "creditCardFeeOffsetInCents": 88,
      ])
    ).run(Self.app, variables: ["input": input])
  }

  func testCreatePrintJob() async throws {
    var payload: Lulu.Api.CreatePrintJobBody!

    Current.luluClient.createPrintJob = {
      payload = $0
      return .init(id: 1, status: .init(name: .created), lineItems: [])
    }

    let entities = await Entities.create()
    let order = Order.random
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = entities.edition.id
    try await Current.db.create(order)
    try await Current.db.create(item)

    let job = try await PrintJobs.create(order)

    XCTAssertEqual(1, job.id)
    XCTAssertEqual(
      payload,
      .init(
        shippingLevel: order.shippingLevel.lulu,
        shippingAddress: order.address.lulu,
        contactEmail: "jared@netrivet.com",
        externalId: order.id.rawValue.uuidString,
        lineItems: [.init(
          title: entities.document.title,
          cover: entities.editionImpression.files.paperback.cover.first.sourceUrl.absoluteString,
          interior: entities.editionImpression.files.paperback.interior.first.sourceUrl
            .absoluteString,
          podPackageId: Lulu.podPackageId(
            size: entities.editionImpression.paperbackSizeVariant.printSize,
            pages: entities.editionImpression.paperbackVolumes.first
          ),
          quantity: item.quantity
        )]
      )
    )
  }

  func testCreatePrintJobWithFauxVolumes() async throws {
    var payload: Lulu.Api.CreatePrintJobBody!

    Current.luluClient.createPrintJob = {
      payload = $0
      return .init(id: 1, status: .init(name: .created), lineItems: [])
    }

    let entities = await Entities.create {
      $0.editionImpression.paperbackVolumes = .init(123)
      $0.editionImpression.paperbackVolumes.append(234)
    }
    let order = Order.random
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = entities.edition.id
    try await Current.db.create(order)
    try await Current.db.create(item)

    let job = try await PrintJobs.create(order)

    XCTAssertEqual(1, job.id)
    XCTAssertEqual(
      payload,
      .init(
        shippingLevel: order.shippingLevel.lulu,
        shippingAddress: order.address.lulu,
        contactEmail: "jared@netrivet.com",
        externalId: order.id.rawValue.uuidString,
        lineItems: [
          .init(
            title: entities.document.title + ", vol. 1",
            cover: entities.editionImpression.files.paperback.cover.first.sourceUrl.absoluteString,
            interior: entities.editionImpression.files.paperback.interior.first.sourceUrl
              .absoluteString,
            podPackageId: Lulu.podPackageId(
              size: entities.editionImpression.paperbackSizeVariant.printSize,
              pages: entities.editionImpression.paperbackVolumes.first
            ),
            quantity: item.quantity
          ),
          .init(
            title: entities.document.title + ", vol. 2",
            cover: entities.editionImpression.files.paperback.cover[1].sourceUrl.absoluteString,
            interior: entities.editionImpression.files.paperback.interior[1].sourceUrl
              .absoluteString,
            podPackageId: Lulu.podPackageId(
              size: entities.editionImpression.paperbackSizeVariant.printSize,
              pages: entities.editionImpression.paperbackVolumes.first
            ),
            quantity: item.quantity
          ),
        ]
      )
    )
  }

  func testGetExploratoryMetadata() async throws {
    let responses = Responses([
      .init(shipping: "9.99", tax: "3.33", total: "19.12", fee: "1.50"),
      .init(shipping: "10.99", tax: "4.33", total: "20.12", fee: "1.50"),
    ])

    Current.luluClient.createPrintJobCostCalculation = { _, _, _ in
      await responses.next()
    }

    let meta = try await PrintJobs.getExploratoryMetadata(
      for: [.init(volumes: .init(259), printSize: .m, quantity: 1)],
      shippedTo: .mock
    )
    XCTAssertEqual(meta.creditCardFeeOffset, 88)
    XCTAssertEqual(meta.shipping, 999)
    XCTAssertEqual(meta.taxes, 333)
    XCTAssertEqual(meta.fees, 150)
  }

  func testCreditCardFeeOffset() throws {
    let cases = [
      (455, 44),
      (1135, 65),
      (1426, 73),
      (1912, 88),
      (726, 53),
      (13945, 447),
      (4823, 175),
      (24550, 765),
      (41917, 1282),
    ]

    for (input, expected) in cases {
      let actual = try PrintJobs.creditCardFeeOffset(.init(rawValue: input))
      XCTAssertEqual(actual, .init(rawValue: expected))
    }
  }
}

private actor Responses {
  var responses: [Lulu.Api.PrintJobCostCalculationResponse]

  init(_ responses: [Lulu.Api.PrintJobCostCalculationResponse]) {
    self.responses = responses
  }

  func next() -> Lulu.Api.PrintJobCostCalculationResponse {
    if responses.count == 1 { return responses[0] }
    return responses.removeFirst()
  }
}
