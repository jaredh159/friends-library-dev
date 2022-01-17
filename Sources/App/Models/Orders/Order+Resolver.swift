import Vapor

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
      try await Current.db.create(order)
      try await Current.db.create(items)
      return order
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
      try await Current.db.query(Order.self)
        .where(.printJobStatus == .enum(args.printJobStatus))
        .all()
    }
  }
}

// below auto-generated

extension Resolver {
  func getOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.find(Order.self, byId: args.id)
    }
  }

  func getOrders(req: Req, args: NoArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.query(Order.self).all()
    }
  }

  func createOrder(
    req: Req,
    args: AppSchema.CreateOrderArgs
  ) throws -> Future<Order> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.create(Order(args.input))
    }
  }

  func createOrders(
    req: Req,
    args: AppSchema.CreateOrdersArgs
  ) throws -> Future<[Order]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Order.init))
    }
  }

  func updateOrder(
    req: Req,
    args: AppSchema.UpdateOrderArgs
  ) throws -> Future<Order> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.update(Order(args.input))
    }
  }

  func updateOrders(
    req: Req,
    args: AppSchema.UpdateOrdersArgs
  ) throws -> Future<[Order]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Order.init))
    }
  }

  func deleteOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.delete(Order.self, byId: args.id)
    }
  }
}
