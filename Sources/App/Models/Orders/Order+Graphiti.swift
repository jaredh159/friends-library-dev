import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Order {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<OrderItem>
  ) where FieldType == [TypeRef<OrderItem>] {
    self.init(
      name.description,
      at: resolveChildren { order, eventLoop -> Future<[OrderItem]> in
        switch order.items {
          case .notLoaded:
            throw Abort(.notImplemented, reason: "Order.items should always be eagerly loaded.")
          case let .loaded(orderChildren):
            return eventLoop.makeSucceededFuture(orderChildren)
        }
      },
      as: [TypeRef<OrderItem>].self)
  }
}
