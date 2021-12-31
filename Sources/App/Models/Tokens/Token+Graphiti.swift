import Fluent
import Graphiti
import Vapor

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
            return future(of: [TokenScope].self, on: eventLoop) {
              try await Current.db.getTokenScopes(token.id)
            }
          case let .loaded(tokenChildren):
            return eventLoop.makeSucceededFuture(tokenChildren)
        }
      },
      as: [TypeRef<TokenScope>].self)
  }
}
