import Fluent
import Graphiti
import Vapor

extension Graphiti.Field {
  typealias TypeRef = TypeReference
  typealias ToChildren<M: AppModel> = KeyPath<ObjectType, Children<M>>
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Token {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<TokenScope>
  ) where FieldType == [TypeRef<TokenScope>] {
    self.init(
      name.description,
      at: resolveChildren { token, eventLoop -> Future<[TokenScope]> in
        switch token.scopes {
          case .notLoaded:
            let promise = eventLoop.makePromise(of: [TokenScope].self)
            promise.completeWithTask {
              try await Current.db.getTokenScopes(token.id)
            }
            return promise.futureResult
          case let .loaded(scopes):
            return eventLoop.makeSucceededFuture(scopes)
        }
      },
      as: [TypeRef<TokenScope>].self)
  }
}

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
          case let .loaded(items):
            return eventLoop.makeSucceededFuture(items)
        }
      },
      as: [TypeRef<OrderItem>].self)
  }
}

private func resolveChildren<P: AppModel, C: AppModel>(
  _ f: @escaping (P, EventLoop) throws -> Future<[C]>
) -> (P) -> (Req, NoArgs, EventLoopGroup) throws -> Future<[C]> {
  { parent in
    { _, _, elg in
      try f(parent, elg.next())
    }
  }
}
