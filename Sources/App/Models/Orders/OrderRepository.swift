import FluentSQL
import Vapor

struct OrderRepository {
  var db: SQLDatabase

  func createOrderWithItems(_ order: Order) async throws {
    try await create(order)
    guard case let .loaded(items) = order.items, !items.isEmpty else {
      return
    }
    try await createRelations(items)
  }

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) async throws -> [Order] {
    try await select(where: (Order[.printJobStatus], .equals, .enum(status)))
  }

  func updateOrder(_ input: UpdateOrderInput) async throws -> Order {
    if input.printJobStatus == nil && input.printJobId == nil {
      return try await find(.init(rawValue: input.id))
    }

    var setPairs: [String: Postgres.Data] = [
      Order[.updatedAt]: .currentTimestamp
    ]

    if let status = input.printJobStatus {
      setPairs[Order[.printJobStatus]] = .enum(status)
    }

    if let printJobId = input.printJobId {
      setPairs[Order[.printJobId]] = .int(printJobId)
    }

    return try await updateReturning(
      Order.self,
      set: setPairs,
      where: (Order[.id], .equals, .uuid(input.id))
    ).firstOrThrowNotFound()
  }
}

struct MockOrderRepository {
  var db: MockDb

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) async throws -> [Order] {
    try await select(where: { $0.printJobStatus == status })
  }

  func updateOrder(_ input: UpdateOrderInput) async throws -> Order {
    let order = try db.find(.init(rawValue: input.id), in: \.orders)
    if let printJobId = input.printJobId {
      order.printJobId = .init(rawValue: printJobId)
    }
    if let printJobStatus = input.printJobStatus {
      order.printJobStatus = printJobStatus
    }
    return order
  }
}

/// extensions

extension OrderRepository: LiveRepository {
  typealias Model = Order

  func assign(client: inout DatabaseClient) {
    client.deleteAllOrders = deleteAll
    client.createOrderWithItems = { try await createOrderWithItems($0) }
    client.getOrder = { try await find($0) }
    client.updateOrder = { try await updateOrder($0) }
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
    client.updateOrder = { try await updateOrder($0) }
    client.getOrdersByPrintJobStatus = { try await getOrdersByPrintJobStatus($0) }
  }
}
