import Foundation
import XCTVapor
import XCTVaporUtils

@testable import App

final class OrderInitializationTests: AppTestCase {

  func testCreateOrderInitializationSuccess() async throws {
    var uuids = [
      "0d70e2a5-2cda-4326-b9cf-f28e70f580e8", // order id
      "552444a7-b8c6-4e65-8787-1a91cd96e9ac", // token id (not asserted)
      "c53d0162-4d81-4ff5-8370-48df861a03d5", // token value
    ]

    Current.uuid = { guard !uuids.isEmpty else { return UUID() }
      return UUID(uuidString: uuids.removeFirst())!
    }

    Current.stripeClient.createPaymentIntent = { amount, orderId in
      XCTAssertEqual(amount, 555)
      XCTAssertEqual(orderId.rawValue.lowercased, "0d70e2a5-2cda-4326-b9cf-f28e70f580e8")
      return .init(id: "pi_id", clientSecret: "pi_secret")
    }

    GraphQLTest(
      """
      mutation CreateOrderInitialization($input: CreateOrderInitializationInput!) {
        createOrderInitialization(input: $input) {
          orderPaymentId
          stripeClientSecret
          orderId
          createOrderToken
        }
      }
      """,
      expectedData: .containsKVPs([
        "orderPaymentId": "pi_id",
        "stripeClientSecret": "pi_secret",
        "orderId": "0d70e2a5-2cda-4326-b9cf-f28e70f580e8",
        "createOrderToken": "c53d0162-4d81-4ff5-8370-48df861a03d5",
      ])
    ).run(Self.app, variables: ["input": .dictionary(["amount": .int(555)])])
  }

  func testCreateOrderInitializationFailure() async throws {
    Current.stripeClient.createPaymentIntent = { _, _ in throw "some error" }
    var slacksSent: [Slack.Message] = []
    Current.slackClient.send = { slacksSent.append($0) }

    GraphQLTest(
      """
      mutation CreateOrderInitialization($input: CreateOrderInitializationInput!) {
        createOrderInitialization(input: $input) {
          orderPaymentId
          stripeClientSecret
          orderId
          createOrderToken
        }
      }
      """,
      expectedError: .status(.internalServerError)
    ).run(Self.app, variables: ["input": .dictionary(["amount": .int(555)])])

    XCTAssertEqual(slacksSent, [.error("Error creating OrderInitialization: some error")])
  }
}
