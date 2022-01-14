import Vapor

// below auto-generated

extension Resolver {
  func getOrderItem(req: Req, args: IdentifyEntityArgs) throws -> Future<OrderItem> {
    try req.requirePermission(to: .queryFriends)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.find(OrderItem.self, byId: args.id)
    }
  }

  func getOrderItems(req: Req, args: NoArgs) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.query(OrderItem.self).all()
    }
  }

  func createOrderItem(
    req: Req,
    args: AppSchema.CreateOrderItemArgs
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.create(OrderItem(args.input))
    }
  }

  func createOrderItems(
    req: Req,
    args: AppSchema.CreateOrderItemsArgs
  ) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(OrderItem.init))
    }
  }

  func updateOrderItem(
    req: Req,
    args: AppSchema.UpdateOrderItemArgs
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.update(OrderItem(args.input))
    }
  }

  func updateOrderItems(
    req: Req,
    args: AppSchema.UpdateOrderItemsArgs
  ) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(OrderItem.init))
    }
  }

  func deleteOrderItem(req: Req, args: IdentifyEntityArgs) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.delete(OrderItem.self, byId: args.id)
    }
  }
}
