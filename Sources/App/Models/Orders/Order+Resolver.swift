import Fluent
import Foundation
import Graphiti
import TaggedMoney
import Vapor

struct CreateOrderWithItemsArgs: Codable {
  let order: AppSchema.CreateOrderInput
  let items: [AppSchema.CreateOrderItemInput]
}

extension Resolver {

  func createOrderWithItems(req: Req, args: CreateOrderWithItemsArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateOrders)
    let order = Order(args.order)
    let items = args.items.map(OrderItem.init)
    order.items = .loaded(items)
    return future(of: Order.self, on: req.eventLoop) {
      _ = try await Current.db.createOrder(order)
      _ = try await Current.db.createOrderItems(items)
      return order
    }
  }

  func getOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    try req.requirePermission(to: .queryOrders)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.getOrder(.init(rawValue: args.id))
    }
  }

  struct GetOrdersByPrintJobStatusArgs: Codable {
    let printJobStatus: Order.PrintJobStatus
  }

  func getOrdersByPrintJobStatus(
    req: Req,
    args: GetOrdersByPrintJobStatusArgs
  ) throws -> Future<[Order]> {
    try req.requirePermission(to: .queryOrders)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.getOrders(Order[.printJobStatus] == .enum(args.printJobStatus))
    }
  }

  func updateOrder(req: Req, args: AppSchema.UpdateOrderArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.updateOrder(Order(args.input))
    }
  }

  func updateOrders(req: Req, args: AppSchema.UpdateOrdersArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.updateOrders(args.input.map(Order.init))
    }
  }
}

// below auto-generated

extension Resolver {

  func getOrders(req: Req, args: NoArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .queryOrders)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.getOrders(nil)
    }
  }

  func createOrder(req: Req, args: AppSchema.CreateOrderArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.createOrder(Order(args.input))
    }
  }

  func createOrders(req: Req, args: AppSchema.CreateOrdersArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.createOrders(args.input.map(Order.init))
    }
  }

  func deleteOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.deleteOrder(.init(rawValue: args.id))
    }
  }
}
