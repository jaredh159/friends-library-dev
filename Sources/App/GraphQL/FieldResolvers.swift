import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArguments, Context == Request, ObjectType: Token {

  convenience init(
    _ name: FieldKey,
    with keyPath: KeyPath<ObjectType, Children<TokenScope>>
  ) where FieldType == [TypeReference<TokenScope>] {
    self.init(
      name.description,
      at: {
        (model) -> (Request, NoArguments, EventLoopGroup) throws -> Future<[TokenScope]> in
        return { (_, _, eventLoopGroup) in
          switch model.scopes {
            case .notLoaded:
              return try Current.db.getTokenScopes(model.id)
            case let .loaded(scopes):
              return eventLoopGroup.next().makeSucceededFuture(scopes)
          }
        }
      }, as: [TypeReference<TokenScope>].self)
  }
}
