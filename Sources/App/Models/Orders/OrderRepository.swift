import FluentSQL
import Vapor

struct OrderRepository {
  var db: SQLDatabase

  func createOrder(_ order: Order) throws -> Future<Void> {
    db.raw(
      """
      INSERT INTO \(table: Order.self)
      (
        \(col: Order[.id]),
        \(col: Order[.paymentId]),
        \(col: Order[.printJobStatus]),
        \(col: Order[.printJobId]),
        \(col: Order[.amount]),
        \(col: Order[.shipping]),
        \(col: Order[.taxes]),
        \(col: Order[.ccFeeOffset]),
        \(col: Order[.shippingLevel]),
        \(col: Order[.email]),
        \(col: Order[.addressName]),
        \(col: Order[.addressStreet]),
        \(col: Order[.addressStreet2]),
        \(col: Order[.addressCity]),
        \(col: Order[.addressState]),
        \(col: Order[.addressZip]),
        \(col: Order[.addressCountry]),
        \(col: Order[.lang]),
        \(col: Order[.source]),
        \(col: Order[.createdAt]),
        \(col: Order[.updatedAt]),
        free_order_request_id -- @TODO
      ) VALUES (
        '\(id: order.id)',
        \(nullable: order.paymentId.rawValue),
        '\(raw: order.printJobStatus.rawValue)',
        \(nullable: order.printJobId?.rawValue),
        \(literal: order.amount.rawValue),
        \(literal: order.shipping.rawValue),
        \(literal: order.taxes.rawValue),
        \(literal: order.ccFeeOffset.rawValue),
        '\(raw: order.shippingLevel.rawValue)',
        '\(raw: order.email.rawValue)',
        '\(raw: order.addressName)',
        '\(raw: order.addressStreet)',
        \(nullable: order.addressStreet2),
        '\(raw: order.addressCity)',
        '\(raw: order.addressState)',
        '\(raw: order.addressZip)',
        '\(raw: order.addressCountry)',
        '\(raw: order.lang.rawValue)',
        '\(raw: order.source.rawValue)',
        current_timestamp,
        current_timestamp,
        NULL
      );
      """
    ).all().map { _ in }
  }

  func getOrder(_ id: Order.Id) throws -> Future<Order> {
    db.raw(
      """
      SELECT * FROM \(table: Order.self)
      WHERE "\(col: Order[.id])" = '\(id: id)'
      """
    ).all().flatMapThrowing { rows -> Order in
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
