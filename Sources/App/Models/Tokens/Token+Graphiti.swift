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
      at: resolveChildren { (token) async throws -> [TokenScope] in
        switch token.scopes {
          case .notLoaded:
            return try await Current.db.getTokenTokenScopes(token.id)
          case let .loaded(tokenChildren):
            return tokenChildren
        }
      },
      as: [TypeRef<TokenScope>].self)
  }
}
