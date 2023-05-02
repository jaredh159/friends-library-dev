import GraphQL
import XCTest

@testable import App
@testable import XStripe

final class OrderResolverTests: AppTestCase {

  func testCreateOrder() async throws {
    let entities = await Entities.create()
    let order = Order.random
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = entities.edition.id
    let orderMap = order.gqlMap()
    let itemMap = item.gqlMap()

    assertResponse(
      to: /* gql */ """
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
            unitPriceInCents
            order {
              itemOrderId: id
            }
            edition {
              itemEditionId: id
            }
          }
        }
      }
      """,
      withVariables: ["order": orderMap, "items": .array([itemMap])],
      .containsKeyValuePairs([
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
        "unitPriceInCents": itemMap["unitPrice"],
      ])
    )
  }

  func testCreateOrderAbbreviatesUSStates() async throws {
    let entities = await Entities.create()
    let order = Order.random
    order.addressCountry = "US"
    order.addressState = "California" // <-- should be abbreviated to CA
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = entities.edition.id
    let orderMap = order.gqlMap()
    let itemMap = item.gqlMap()

    assertResponse(
      to: /* gql */ """
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
            unitPriceInCents
            order {
              itemOrderId: id
            }
            edition {
              itemEditionId: id
            }
          }
        }
      }
      """,
      withVariables: ["order": orderMap, "items": .array([itemMap])],
      .containsKeyValuePairs([
        "paymentId": orderMap["paymentId"],
        "itemOrderId": orderMap["id"],
        "itemEditionId": entities.edition.id.lowercased,
        "printJobStatus": orderMap["printJobStatus"],
        "shippingLevel": orderMap["shippingLevel"],
        "email": orderMap["email"],
        "addressName": orderMap["addressName"],
        "addressStreet": orderMap["addressStreet"],
        "addressCity": orderMap["addressCity"],
        "addressState": "CA", // <-- abbreviated
        "addressZip": orderMap["addressZip"],
        "addressCountry": orderMap["addressCountry"],
        "lang": orderMap["lang"],
        "source": orderMap["source"],
        "quantity": itemMap["quantity"],
        "unitPriceInCents": itemMap["unitPrice"],
      ])
    )
  }

  func testCreateOrderWithFreeRequestId() async throws {
    let edition = await Entities.create().edition
    let req = try await Current.db.create(FreeOrderRequest.random)
    let order = Order.random
    order.freeOrderRequestId = req.id
    let item = OrderItem.random
    item.orderId = order.id
    item.editionId = edition.id

    assertResponse(
      to: /* gql */ """
      mutation CreateOrderWithItems($order: CreateOrderInput!, $items: [CreateOrderItemInput!]!) {
        order: createOrderWithItems(order: $order, items: $items) {
          freeOrderRequest {
            id
          }
        }
      }
      """,
      withVariables: ["order": order.gqlMap(), "items": [item.gqlMap()]],
      .containsKeyValuePairs(["id": req.id.lowercased])
    )
  }

  func testUpdateOrder() async throws {
    let order = try await Current.db.create(Order.empty)

    // now update
    order.printJobId = 12345
    order.printJobStatus = .accepted

    assertResponse(
      to: /* gql */ """
      mutation UpdateOrder($input: UpdateOrderInput!) {
        order: updateOrder(input: $input) {
          printJobId
          printJobStatus
        }
      }
      """,
      withVariables: ["input": order.gqlMap()],
      .containsKeyValuePairs([
        "printJobId": 12345,
        "printJobStatus": "accepted",
      ])
    )
  }

  func testUpdateOrders() async throws {
    let order1 = try await Current.db.create(Order.empty)
    let order2 = try await Current.db.create(Order.empty)

    // now update
    order1.printJobId = 5555
    order2.printJobId = 3333

    assertResponse(
      to: /* gql */ """
      mutation UpdateOrders($input: [UpdateOrderInput!]!) {
        order: updateOrders(input: $input) {
          printJobId
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": .array([order1.gqlMap(), order2.gqlMap()])],
      .containsAll(["5555", "3333"])
    )
  }

  func testGetOrderDirectionId() async throws {
    let order = Order.empty
    order.printJobId = 234_432
    try await Current.db.create(order)

    assertResponse(
      to: /* gql */ """
      query {
        order: getOrder(id: "\(order.id.uuidString)") {
          printJobId
        }
      }
      """,
      .containsKeyValuePairs(["printJobId": 234_432])
    )
  }

  func testGetOrderDirectionIdFailsWithWrongTokenScope() async throws {
    Current.auth = .live
    let order = try await Current.db.create(Order.empty)

    assertResponse(
      to: /* gql */ """
      query {
        order: getOrder(id: "\(order.id.uuidString)") {
          printJobId
        }
      }
      """,
      bearer: Seeded.tokens.queryDownloads, // 👋 <-- bad scope
      isError: .withStatus(.unauthorized)
    )
  }

  func testBrickOrder() async throws {
    let order = Order.random
    order.printJobStatus = .presubmit
    order.paymentId = .init(rawValue: "stripe_pi_id")
    try await Current.db.create(order)

    var refundedPaymentIntentId: String?
    Current.stripeClient.createRefund = { pi, _ in
      refundedPaymentIntentId = pi
      return .init(id: "pi_refund_id")
    }

    var canceledPaymentId: String?
    Current.stripeClient.cancelPaymentIntent = { pi, _ in
      canceledPaymentId = pi
      return .init(id: pi, clientSecret: "")
    }

    let input: Map = .dictionary([
      "orderId": .string(order.id.lowercased),
      "orderPaymentId": "stripe_pi_id",
      "userAgent": "operafox",
      "stateHistory": .array(["foo", "bar"]),
    ])

    assertResponse(
      to: /* gql */ """
      mutation BrickOrder($input: BrickOrderInput!) {
        brickOrder(input: $input) {
          success
        }
      }
      """,
      withVariables: ["input": input],
      .containsKeyValuePairs(["success": true])
    )

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
