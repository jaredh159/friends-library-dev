import XCTest
import XExpect

@testable import App
@testable import XStripe

final class OrderInitializationTests: AppTestCase {

  func testCreateOrderInitializationSuccess() async throws {
    try await Current.db.deleteAll(Token.self)

    let (orderId, _, tokenValue) = mockUUIDs()

    Current.stripeClient.createPaymentIntent = { amount, currency, metadata, _ in
      expect(amount).toEqual(555)
      expect(currency).toEqual(.USD)
      expect(metadata).toEqual(["orderId": orderId.lowercased])
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
        "orderId": orderId.lowercased,
        "createOrderToken": tokenValue.lowercased,
      ])
    )
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
