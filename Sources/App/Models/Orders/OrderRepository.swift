import FluentSQL
import Vapor

struct OrderRepository {
  var db: SQLDatabase

  func createOrderWithItems(_ order: Order) async throws -> Order {
    try await create(order)
    guard case let .loaded(items) = order.items, !items.isEmpty else {
      return order
    }
    try await createRelations(items)
    return order
  }

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) async throws -> [Order] {
    try await select(where: (Order[.printJobStatus], .equals, .enum(status)))
  }
}

struct MockOrderRepository {
  var db: MockDb

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) async throws -> [Order] {
    try await select(where: { $0.printJobStatus == status })
  }
}

/// extensions

extension OrderRepository: LiveRepository {
  typealias Model = Order

  func assign(client: inout DatabaseClient) {
    client.deleteAllOrders = deleteAll
    client.createOrderWithItems = { try await createOrderWithItems($0) }
    client.getOrder = { try await find($0) }
    client.updateOrder = { try await update($0) }
    client.updateOrders = { try await update($0) }
    client.getOrdersByPrintJobStatus = { try await getOrdersByPrintJobStatus($0) }
  }
}

extension MockOrderRepository: MockRepository {
  typealias Model = Order
  var models: ModelsPath { \.orders }

  func assign(client: inout DatabaseClient) {
    client.deleteAllOrders = deleteAll
    client.createOrderWithItems = { try await create($0) }
    client.getOrder = { try await find($0) }
    client.updateOrder = { try await update($0) }
    client.updateOrders = { try await update($0) }
    client.getOrdersByPrintJobStatus = { try await getOrdersByPrintJobStatus($0) }
  }
}
