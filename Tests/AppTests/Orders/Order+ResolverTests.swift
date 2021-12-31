import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class OrderResolverTests: AppTestCase {

  func testCreateOrder() throws {
    let order = Order.random
    let item = OrderItem.random
    item.orderId = order.id
    let orderMap = order.gqlMap()
    let itemMap = item.gqlMap()

    GraphQLTest(
      """
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
            title
            documentId
            editionType
            quantity
            unitPrice
          }
        }
      }
      """,
      expectedData: .containsKVPs([
        "paymentId": orderMap["paymentId"],
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
        "title": itemMap["title"],
        "documentId": itemMap["documentId"],
        "editionType": itemMap["editionType"],
        "quantity": itemMap["quantity"],
        "unitPrice": itemMap["unitPrice"],
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["order": orderMap, "items": .array([itemMap])])
  }

  func testCreateOrderWithFreeRequestId() async throws {
    let req = FreeOrderRequest.random
    try await Current.db.createFreeOrderRequest(req)
    let order = Order.random
    order.freeOrderRequestId = req.id
    let item = OrderItem.random
    item.orderId = order.id

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
      expectedData: .containsKVPs(["id": req.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["order": order.gqlMap(), "items": [item.gqlMap()]])
  }

  func testUpdateOrder() async throws {
    let order = Order.empty
    try await Current.db.createOrderWithItems(order)

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
    let order1 = Order.empty
    let order2 = Order.empty
    try await Current.db.createOrderWithItems(order1)
    try await Current.db.createOrderWithItems(order2)

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

  func testGetOrderById() async throws {
    let order = Order.empty
    order.printJobId = 234432
    try await Current.db.createOrderWithItems(order)

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

  func testGetOrderByIdFailsWithWrongTokenScope() async throws {
    Current.auth = .live
    let order = Order.empty
    try await Current.db.createOrderWithItems(order)
    GraphQLTest(
      """
      query {
        order: getOrder(id: "\(order.id.uuidString)") {
          printJobId
        }
      }
      """,
      expectedError: .status(.unauthorized),
      headers: [.authorization: "Bearer \(Seeded.tokens.queryDownloads)"]  // 👋 <-- bad scope
    ).run(Self.app)
  }

  func testGetOrdersByPrintJobStatus() async throws {
    let order1 = Order.empty
    order1.printJobStatus = .bricked
    let order2 = Order.empty
    order2.printJobStatus = .bricked
    try await Current.db.createOrderWithItems(order1)
    try await Current.db.createOrderWithItems(order2)

    GraphQLTest(
      """
      query {
        getOrdersByPrintJobStatus(printJobStatus: bricked) {
          id
        }
      }
      """,
      expectedData: .containsUUIDs([order1.id.rawValue, order2.id.rawValue]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }
}
