import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class OrderResolverTests: AppTestCase {

  func testCreateOrder() async throws {
    let entities = await Entities.create()
    let order = Order.random
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = entities.edition.id
    let orderMap = order.gqlMap()
    let itemMap = item.gqlMap()

    let query = """
    mutation CreateOrderWithItems($order: CreateOrderInput!, $items: [CreateOrderItemInput!]!) {
      order: createOrderWithItems(order: $order, items: $items) {
        paymentId
        printJobStatus
        shippingLevel
        email
        addressName
        addressStreet
        addressCity
        addressState
        addressZip
        addressCountry
        lang
        source
        items {
          quantity
          unitPrice
          order {
            itemOrderId: id
          }
          edition {
            itemEditionId: id
          }
        }
      }
    }
    """

    let expectedData = GraphQLTest.ExpectedData.containsKVPs([
      "paymentId": orderMap["paymentId"],
      "itemOrderId": orderMap["id"],
      "itemEditionId": entities.edition.id.lowercased,
      "printJobStatus": orderMap["printJobStatus"],
      "shippingLevel": orderMap["shippingLevel"],
      "email": orderMap["email"],
      "addressName": orderMap["addressName"],
      "addressStreet": orderMap["addressStreet"],
      "addressCity": orderMap["addressCity"],
      "addressState": orderMap["addressState"],
      "addressZip": orderMap["addressZip"],
      "addressCountry": orderMap["addressCountry"],
      "lang": orderMap["lang"],
      "source": orderMap["source"],
      "quantity": itemMap["quantity"],
      "unitPrice": itemMap["unitPrice"],
    ])

    GraphQLTest(
      query,
      expectedData: expectedData,
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["order": orderMap, "items": .array([itemMap])])
  }

  func testCreateOrderWithFreeRequestId() async throws {
    let edition = await Entities.create().edition
    let req = try await Current.db.create(FreeOrderRequest.random)
    let order = Order.random
    order.freeOrderRequestId = req.id
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = edition.id

    GraphQLTest(
      """
      mutation CreateOrderWithItems($order: CreateOrderInput!, $items: [CreateOrderItemInput!]!) {
        order: createOrderWithItems(order: $order, items: $items) {
          freeOrderRequest {
            id
          }
        }
      }
      """,
      expectedData: .containsKVPs(["id": req.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["order": order.gqlMap(), "items": [item.gqlMap()]])
  }

  func testUpdateOrder() async throws {
    let order = try await Current.db.create(Order.empty)

    // now update
    order.printJobId = 12345
    order.printJobStatus = .accepted

    GraphQLTest(
      """
      mutation UpdateOrder($input: UpdateOrderInput!) {
        order: updateOrder(input: $input) {
          printJobId
          printJobStatus
        }
      }
      """,
      expectedData: .containsKVPs([
        "printJobId": 12345,
        "printJobStatus": "accepted",
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": order.gqlMap()])
  }

  func testUpdateOrders() async throws {
    let order1 = try await Current.db.create(Order.empty)
    let order2 = try await Current.db.create(Order.empty)

    // now update
    order1.printJobId = 5555
    order2.printJobId = 3333

    GraphQLTest(
      """
      mutation UpdateOrders($input: [UpdateOrderInput!]!) {
        order: updateOrders(input: $input) {
          printJobId
        }
      }
      """,
      expectedData: .containsAll(["5555", "3333"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": .array([order1.gqlMap(), order2.gqlMap()])])
  }

  func testGetOrderDirectionId() async throws {
    let order = Order.empty
    order.printJobId = 234432
    try await Current.db.create(order)

    GraphQLTest(
      """
      query {
        order: getOrder(id: "\(order.id.uuidString)") {
          printJobId
        }
      }
      """,
      expectedData: .containsKVPs(["printJobId": 234432]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testGetOrderDirectionIdFailsWithWrongTokenScope() async throws {
    Current.auth = .live
    let order = try await Current.db.create(Order.empty)
    GraphQLTest(
      """
      query {
        order: getOrder(id: "\(order.id.uuidString)") {
          printJobId
        }
      }
      """,
      expectedError: .status(.unauthorized),
      headers: [.authorization: "Bearer \(Seeded.tokens.queryDownloads)"] // 👋 <-- bad scope
    ).run(Self.app)
  }

  func testBrickOrder() async throws {
    let order = Order.random
    order.printJobStatus = .presubmit
    order.paymentId = .init(rawValue: "stripe_pi_id")
    try await Current.db.create(order)

    var refundedPaymentIntentId: String?
    Current.stripeClient.createRefund = {
      refundedPaymentIntentId = $0
      return .init(id: "pi_refund_id")
    }

    var canceledPaymentId: String?
    Current.stripeClient.cancelPaymentIntent = {
      canceledPaymentId = $0
      return .init(id: $0, clientSecret: "")
    }

    let input: Map = .dictionary([
      "orderId": .string(order.id.lowercased),
      "orderPaymentId": "stripe_pi_id",
      "userAgent": "operafox",
      "stateHistory": .array(["foo", "bar"]),
    ])

    GraphQLTest(
      """
      mutation BrickOrder($input: BrickOrderInput!) {
        brickOrder(input: $input) {
          success
        }
      }
      """,
      expectedData: .containsKVPs(["success": true])
    ).run(Self.app, variables: ["input": input])

    let retrieved = try await Current.db.find(order.id)
    XCTAssertEqual(retrieved.printJobStatus, .bricked)
    XCTAssertEqual(refundedPaymentIntentId, "stripe_pi_id")
    XCTAssertEqual(canceledPaymentId, "stripe_pi_id")
    let orderId = order.id.lowercased
    XCTAssertEqual(
      sent.slacks,
      [
        .error("Created stripe refund `pi_refund_id` for bricked order `\(orderId)`"),
        .error("Canceled stripe payment intent `stripe_pi_id` for bricked order `\(orderId)`"),
        .error("Updated order `\(orderId)` to printJobStatus `.bricked`"),
        .error("""
        *Bricked Order*
        ```
        \(JSON.encode(
          BrickOrderInput(
            orderPaymentId: "stripe_pi_id",
            orderId: orderId,
            userAgent: "operafox",
            stateHistory: ["foo", "bar"]
          ), .pretty)!)
        ```
        """),
      ]
    )
  }
}
