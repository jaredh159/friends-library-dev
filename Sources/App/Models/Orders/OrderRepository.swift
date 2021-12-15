import FluentSQL
import Vapor

struct OrderRepository {
  var db: SQLDatabase

  func createOrder(_ order: Order) throws -> Future<Void> {
    let query = insert(
      into: Order.tableName,
      values: [
        Order[.id]: .uuid(order.id.rawValue),
        Order[.paymentId]: .string(order.paymentId.rawValue),
        Order[.printJobStatus]: .enum(order.printJobStatus),
        Order[.printJobId]: .int(order.printJobId?.rawValue),
        Order[.amount]: .int(order.amount.rawValue),
        Order[.shipping]: .int(order.shipping.rawValue),
        Order[.taxes]: .int(order.taxes.rawValue),
        Order[.ccFeeOffset]: .int(order.ccFeeOffset.rawValue),
        Order[.shippingLevel]: .enum(order.shippingLevel),
        Order[.email]: .string(order.email.rawValue),
        Order[.addressName]: .string(order.addressName),
        Order[.addressStreet]: .string(order.addressStreet),
        Order[.addressStreet2]: .string(order.addressStreet2),
        Order[.addressCity]: .string(order.addressCity),
        Order[.addressState]: .string(order.addressState),
        Order[.addressZip]: .string(order.addressZip),
        Order[.addressCountry]: .string(order.addressCountry),
        Order[.lang]: .enum(order.lang),
        Order[.source]: .enum(order.source),
        Order[.createdAt]: .currentTimestamp,
        Order[.updatedAt]: .currentTimestamp,
      ]
    )

    return try execute(query, on: db)
      .flatMap { $0.all() }.map { _ in }
  }

  func getOrder(_ id: Order.Id) throws -> Future<Order> {
    let select = select(.all, from: Order.self, where: (Order[.id], .equals, .uuid(id)))
    return try execute(select, on: db)
      .flatMap { $0.all() }
      .flatMapThrowing { rows -> Order in
        guard let row = rows.first else { throw DbError.notFound }
        return try row.decode(Order.self)
      }
  }

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) throws -> Future<[Order]> {
    db.raw(
      """
      SELECT * FROM \(table: Order.self)
      WHERE "\(col: Order[.printJobStatus])" = '\(raw: status.rawValue)'
      """
    ).all().flatMapThrowing { rows in
      try rows.compactMap { try $0.decode(Order.self) }
    }
  }

  func deleteAllOrders() -> Future<Void> {
    db.raw("DELETE FROM \(table: Order.self)").all().map { _ in }
  }

  func updateOrder(_ input: UpdateOrderInput) throws -> Future<Order> {
    if input.printJobStatus == nil && input.printJobId == nil {
      return try getOrder(.init(rawValue: input.id))
    }

    var fragments: [String] = []
    if let status = input.printJobStatus {
      fragments.append("\(Order.columnName(.printJobStatus)) = '\(status.rawValue)'")
    }
    if let printJobId = input.printJobId {
      fragments.append("\(Order.columnName(.printJobId)) = \(printJobId)")
    }

    return db.raw(
      """
      UPDATE \(table: Order.self)
      SET \(raw: fragments.joined(separator: ", "))
      WHERE \(col: Order[.id]) = '\(raw: input.id.uuidString)'
      RETURNING *
      """
    ).first().flatMapThrowing { row in
      guard let row = row else { throw DbError.notFound }
      return try row.decode(Order.self)
    }
  }
}

struct MockOrderRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func createOrder(_ order: Order) throws -> Future<Void> {
    future(db.add(order, to: \.orders))
  }

  func getOrder(_ id: Order.Id) throws -> Future<Order> {
    try future(db.find(id, in: \.orders))
  }

  func getOrdersByPrintJobStatus(_ status: Order.PrintJobStatus) throws -> Future<[Order]> {
    future(db.find(where: { $0.printJobStatus == status }, in: \.orders))
  }

  func updateOrder(_ input: UpdateOrderInput) throws -> Future<Order> {
    let order = try db.find(.init(rawValue: input.id), in: \.orders)
    if let printJobId = input.printJobId {
      order.printJobId = .init(rawValue: printJobId)
    }
    if let printJobStatus = input.printJobStatus {
      order.printJobStatus = printJobStatus
    }
    return future(order)
  }

  func deleteAllOrders() -> Future<Void> {
    db.orders = [:]
    return future(())
  }
}

/// extensions

extension OrderRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.deleteAllOrders = deleteAllOrders
    client.createOrder = { try createOrder($0) }
    client.getOrder = { try getOrder($0) }
    client.updateOrder = { try updateOrder($0) }
    client.getOrdersByPrintJobStatus = { try getOrdersByPrintJobStatus($0) }
  }
}

extension MockOrderRepository: MockRepository {
  func assign(client: inout DatabaseClient) {
    client.deleteAllOrders = deleteAllOrders
    client.createOrder = { try createOrder($0) }
    client.getOrder = { try getOrder($0) }
    client.updateOrder = { try updateOrder($0) }
    client.getOrdersByPrintJobStatus = { try getOrdersByPrintJobStatus($0) }
  }
}
