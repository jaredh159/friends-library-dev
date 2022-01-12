import FluentSQL
import Vapor

extension Repository where Model == Order {
  func createOrderWithItems(_ order: Order) async throws -> Order {
    try await create(order)
    guard case .loaded(let items) = order.items, !items.isEmpty else {
      return order
    }
    try await createRelations(items)
    return order
  }

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) async throws -> [Order] {
    try await findAll(where: (Order[.printJobStatus], .equals, .enum(status)))
  }

  func assign(client: inout DatabaseClient) {
    client.createOrderWithItems = { try await createOrderWithItems($0) }
    client.getOrdersByPrintJobStatus = { try await getOrdersByPrintJobStatus($0) }
  }
}

extension MockRepository where Model == Order {
  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) async throws -> [Order] {
    try await findAll(where: Order[.printJobStatus] == .enum(status))
  }

  func assign(client: inout DatabaseClient) {
    client.createOrderWithItems = { try await create($0) }
    client.getOrdersByPrintJobStatus = { try await getOrdersByPrintJobStatus($0) }
  }
}
