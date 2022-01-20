import Foundation
import XCTest

@testable import App

final class PrintJobServiceTests: AppTestCase {

  override func setUp() {
    super.setUp()
    Current.luluClient = .mock
  }

  func testGetExploratoryMetadata() async throws {
    let responses = Responses([
      .init(shipping: "9.99", tax: "3.33", total: "19.12", fee: "1.50"),
      .init(shipping: "10.99", tax: "4.33", total: "20.12", fee: "1.50"),
    ])

    Current.luluClient.createPrintJobCostCalculation = { _, _, _ in
      await responses.next()
    }

    let meta = try await PrintJobService.getExploratoryMetadata(
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
      let actual = try PrintJobService.creditCardFeeOffset(.init(rawValue: input))
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
