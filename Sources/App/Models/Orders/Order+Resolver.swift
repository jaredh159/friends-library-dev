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
    order.items = .loaded(args.items.map(OrderItem.init))
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.createOrderWithItems(order)
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
      try await Current.db.getOrdersByPrintJobStatus(args.printJobStatus)
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
    return args.input.map { input in
      future(of: Order.self, on: req.eventLoop) {
        try await Current.db.updateOrder(Order(input))
      }
    }
    .flatten(on: req.eventLoop)
  }

}

// below auto-generated

extension Resolver {

  func getOrders(req: Req, args: NoArgs) throws -> Future<[Order]> {
    throw Abort(.notImplemented)
  }

  func createOrder(req: Req, args: AppSchema.CreateOrderArgs) throws -> Future<Order> {
    throw Abort(.notImplemented)
  }

  func createOrders(req: Req, args: AppSchema.CreateOrdersArgs) throws -> Future<[Order]> {
    throw Abort(.notImplemented)
  }

  func deleteOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    throw Abort(.notImplemented)
  }
}
