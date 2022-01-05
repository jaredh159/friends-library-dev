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
            return try await Current.db.getFriend(friendQuote.friendId)
          case let .loaded(friend):
            return friend
        }
      },
      as: TypeReference<Friend>.self)
  }
}
