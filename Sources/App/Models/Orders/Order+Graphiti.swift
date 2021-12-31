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
      at: resolveChildren { (order) async throws -> [OrderItem] in
        switch order.items {
          case .notLoaded:
            throw Abort(.notImplemented, reason: "Order.items should always be eagerly loaded.")
          case let .loaded(orderChildren):
            return orderChildren
        }
      },
      as: [TypeRef<OrderItem>].self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Order {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalParent<FreeOrderRequest>
  ) where FieldType == TypeRef<FreeOrderRequest>? {
    self.init(
      name.description,
      at: resolveOptionalParent { (order) async throws -> FreeOrderRequest? in
        switch order.freeOrderRequest {
          case .notLoaded:
            guard let freeOrderRequestId = order.freeOrderRequestId else { return nil }
            return try await Current.db.getFreeOrderRequest(freeOrderRequestId)
          case let .loaded(freeOrderRequest):
            return freeOrderRequest
        }
      },
      as: TypeReference<FreeOrderRequest>?.self)
  }
}
