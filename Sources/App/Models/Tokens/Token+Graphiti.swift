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
            let scopes = try await Current.db.getTokenScopes(TokenScope[.tokenId] == .id(token))
            token.scopes = .loaded(scopes)
            return scopes
          case let .loaded(scopes):
            return scopes
        }
      },
      as: [TypeRef<TokenScope>].self)
  }
}
