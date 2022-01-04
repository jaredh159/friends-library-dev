import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: TokenScope {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Token>
  ) where FieldType == TypeRef<Token> {
    self.init(
      name.description,
      at: resolveParent { (tokenScope) async throws -> Token in
        switch tokenScope.token {
          case .notLoaded:
            fatalError("TokenScope -> Parent<Token> not implemented")
          case let .loaded(token):
            return token
        }
      },
      as: TypeReference<Token>.self)
  }
}
