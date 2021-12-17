import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class OrderResolverTests: AppTestCase {

  func testCreateOrder() throws {
    let order: Map = .dictionary([
      "paymentId": .string("stripe-123"),
      "printJobStatus": .string("presubmit"),
      "shippingLevel": .string("mail"),
      "amount": .int(33),
      "shipping": .int(33),
      "taxes": .int(33),
      "ccFeeOffset": .int(33),
      "email": .string("jared@netrivet.com"),
      "addressName": .string("Jared Henderson"),
      "addressStreet": .string("123 Magnolia Lane"),
      "addressCity": .string("New York"),
      "addressState": .string("NY"),
      "addressZip": .string("90210"),
      "addressCountry": .string("US"),
      "lang": .string("en"),
      "source": .string("website"),
      "items": .array([
        .dictionary([
          "title": .string("Journal of George Fox"),
          "documentId": .string("9050edba-197e-498f-9fb8-61c36abae59e"),
          "editionType": .string("original"),
          "quantity": .int(1),
          "unitPrice": .int(333),
        ])
      ]),
    ])

    GraphQLTest(
      """
      mutation CreateOrder($input: CreateOrderInput!) {
        order: createOrder(input: $input) {
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
        "paymentId": "stripe-123",
        "printJobStatus": "presubmit",
        "shippingLevel": "mail",
        "email": "jared@netrivet.com",
        "addressName": "Jared Henderson",
        "addressStreet": "123 Magnolia Lane",
        "addressCity": "New York",
        "addressState": "NY",
        "addressZip": "90210",
        "addressCountry": "US",
        "lang": "en",
        "source": "website",
        "title": "Journal of George Fox",
        "documentId": "9050EDBA-197E-498F-9FB8-61C36ABAE59E",
        "editionType": "original",
        "quantity": 1,
        "unitPrice": 333,
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": order])
  }

  // @TODO
  // func testCreateOrderWithFreeRequestId() throws {
  //   let freeOrderRequest = FreeOrderRequest.createFixture(on: app.db)
  //   let order: Map = .dictionary([
  //     "freeOrderRequestId": .string(freeOrderRequest.id!.uuidString),
  //     "paymentId": .string("stripe-123"),
  //     "printJobStatus": .string("presubmit"),
  //     "shippingLevel": .string("mail"),
  //     "amount": .int(33),
  //     "shipping": .int(33),
  //     "taxes": .int(33),
  //     "ccFeeOffset": .int(33),
  //     "email": .string("jared@netrivet.com"),
  //     "addressName": .string("Jared Henderson"),
  //     "addressStreet": .string("123 Magnolia Lane"),
  //     "addressCity": .string("New York"),
  //     "addressState": .string("NY"),
  //     "addressZip": .string("90210"),
  //     "addressCountry": .string("US"),
  //     "lang": .string("en"),
  //     "source": .string("website"),
  //     "items": .array([
  //       .dictionary([
  //         "title": .string("Journal of George Fox"),
  //         "documentId": .string("9050edba-197e-498f-9fb8-61c36abae59e"),
  //         "editionType": .string("original"),
  //         "quantity": .int(1),
  //         "unitPrice": .int(333),
  //       ])
  //     ]),
  //   ])

  //   GraphQLTest(
  //     """
  //     mutation CreateOrder($input: CreateOrderInput!) {
  //       order: createOrder(input: $input) {
  //         freeOrderRequest {
  //           id
  //         }
  //       }
  //     }
  //     """,
  //     expectedData: .containsKVPs(["id": freeOrderRequest.id!.uuidString]),
  //     headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
  //   ).run(self, variables: ["input": order])
  // }

  func testUpdateOrder() throws {
    let order = Order.empty
    _ = try! Current.db.createOrder(order).wait()

    let input: Map = .dictionary([
      "id": .string(order.id.uuidString),
      "printJobId": .number(12345),
      "printJobStatus": .string("accepted"),
    ])

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
    ).run(Self.app, variables: ["input": input])
  }

  func testUpdateOrders() throws {
    let order1 = Order.empty
    let order2 = Order.empty
    _ = try! Current.db.createOrder(order1).wait()
    _ = try! Current.db.createOrder(order2).wait()

    let input: Map = .array([
      .dictionary([
        "id": .string(order1.id.uuidString),
        "printJobId": .number(5555),
      ]),
      .dictionary([
        "id": .string(order2.id.uuidString),
        "printJobId": .number(3333),
      ]),
    ])

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
    ).run(Self.app, variables: ["input": input])
  }

  func testGetOrderById() throws {
    let order = Order.empty
    order.printJobId = 234432
    _ = try! Current.db.createOrder(order).wait()

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

  func testGetOrderByIdFailsWithWrongTokenScope() throws {
    Current.auth = .live
    let order = Order.empty
    _ = try! Current.db.createOrder(order).wait()
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

  func testGetOrdersByPrintJobStatus() throws {
    let order1 = Order.empty
    order1.printJobStatus = .bricked
    let order2 = Order.empty
    order2.printJobStatus = .bricked
    _ = try! Current.db.createOrder(order1).wait()
    _ = try! Current.db.createOrder(order2).wait()

    GraphQLTest(
      """
      query {
        orders: getOrders(printJobStatus: "bricked") {
          id
        }
      }
      """,
      expectedData: .containsUUIDs([order1.id.rawValue, order2.id.rawValue]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }
}
