import DuetMock
import XCTest

@testable import App
@testable import XStripe

final class OrderInitializationTests: AppTestCase {

  func testCreateOrderInitializationSuccess() async throws {
    try await Current.db.deleteAll(Token.self)

    mockUUIDs([
      "0d70e2a5-2cda-4326-b9cf-f28e70f580e8", // order id
      "552444a7-b8c6-4e65-8787-1a91cd96e9ac", // token id (not asserted)
      "c53d0162-4d81-4ff5-8370-48df861a03d5", // token value
    ])

    Current.stripeClient.createPaymentIntent = { amount, currency, metadata, _ in
      XCTAssertEqual(amount, 555)
      XCTAssertEqual(currency, .USD)
      XCTAssertEqual(metadata, ["orderId": "0d70e2a5-2cda-4326-b9cf-f28e70f580e8"])
      return .init(id: "pi_id", clientSecret: "pi_secret")
    }

    assertResponse(
      to: /* gql */ """
      mutation CreateOrderInitialization($input: CreateOrderInitializationInput!) {
        createOrderInitialization(input: $input) {
          orderPaymentId
          stripeClientSecret
          orderId
          createOrderToken
        }
      }
      """,
      withVariables: ["input": .dictionary(["amount": .int(555)])],
      .containsKeyValuePairs([
        "orderPaymentId": "pi_id",
        "stripeClientSecret": "pi_secret",
        "orderId": "0d70e2a5-2cda-4326-b9cf-f28e70f580e8",
        "createOrderToken": "c53d0162-4d81-4ff5-8370-48df861a03d5",
      ])
    )

    UUID.new = UUID.init
  }

  func testCreateOrderInitializationFailure() async throws {
    Current.stripeClient.createPaymentIntent = { _, _, _, _ in throw "some error" }

    assertResponse(
      to: /* gql */ """
      mutation CreateOrderInitialization($input: CreateOrderInitializationInput!) {
        createOrderInitialization(input: $input) {
          orderPaymentId
          stripeClientSecret
          orderId
          createOrderToken
        }
      }
      """,
      withVariables: ["input": .dictionary(["amount": .int(555)])],
      isError: .withStatus(.internalServerError)
    )

    XCTAssertEqual(sent.slacks, [.error("Error creating OrderInitialization: some error")])
  }
}
