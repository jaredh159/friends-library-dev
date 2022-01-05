import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: OrderItem {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Order>
  ) where FieldType == TypeRef<Order> {
    self.init(
      name.description,
      at: resolveParent { (orderItem) async throws -> Order in
        switch orderItem.order {
          case .notLoaded:
            return try await Current.db.getOrder(orderItem.orderId)
          case let .loaded(order):
            return order
        }
      },
      as: TypeReference<Order>.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: OrderItem {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Edition>
  ) where FieldType == TypeRef<Edition> {
    self.init(
      name.description,
      at: resolveParent { (orderItem) async throws -> Edition in
        switch orderItem.edition {
          case .notLoaded:
            return try await Current.db.getEdition(orderItem.editionId)
          case let .loaded(edition):
            return edition
        }
      },
      as: TypeReference<Edition>.self)
  }
}
