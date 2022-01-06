import Vapor

// below auto-generated

extension Resolver {
  func getOrderItem(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .queryOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.getOrderItem(.init(rawValue: args.id))
    }
  }

  func getOrderItems(
    req: Req,
    args: NoArgs
  ) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .queryOrders)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.getOrderItems(nil)
    }
  }

  func createOrderItem(
    req: Req,
    args: AppSchema.CreateOrderItemArgs
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.createOrderItem(OrderItem(args.input))
    }
  }

  func createOrderItems(
    req: Req,
    args: AppSchema.CreateOrderItemsArgs
  ) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.createOrderItems(args.input.map(OrderItem.init))
    }
  }

  func updateOrderItem(
    req: Req,
    args: AppSchema.UpdateOrderItemArgs
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.updateOrderItem(OrderItem(args.input))
    }
  }

  func updateOrderItems(
    req: Req,
    args: AppSchema.UpdateOrderItemsArgs
  ) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.updateOrderItems(args.input.map(OrderItem.init))
    }
  }

  func deleteOrderItem(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.deleteOrderItem(.init(rawValue: args.id))
    }
  }
}
