import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: FriendQuote {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Friend>
  ) where FieldType == TypeRef<Friend> {
    self.init(
      name.description,
      at: resolveParent { (friendQuote) async throws -> Friend in
        switch friendQuote.friend {
          case .notLoaded:
            // @NEXT
            fatalError("FriendQuote -> Parent<Friend> not implemented")
          case let .loaded(friend):
            return friend
        }
      },
      as: TypeReference<Friend>.self)
  }
}
