import Fluent
import Graphiti
import Vapor

extension Graphiti.Field
where Arguments == NoArgs, Context == Req, ObjectType: FriendResidenceDuration {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<FriendResidence>
  ) where FieldType == TypeRef<FriendResidence> {
    self.init(
      name.description,
      at: resolveParent { (friendResidenceDuration) async throws -> FriendResidence in
        switch friendResidenceDuration.friendResidence {
          case .notLoaded:
            fatalError("FriendResidenceDuration -> Parent<FriendResidence> not implemented")
          case let .loaded(friendResidence):
            return friendResidence
        }
      },
      as: TypeReference<FriendResidence>.self)
  }
}
