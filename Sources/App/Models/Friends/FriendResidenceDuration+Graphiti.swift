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
        switch friendResidenceDuration.residence {
          case .notLoaded:
            return try await Current.db.getFriendResidence(
              friendResidenceDuration.friendResidenceId)
          case let .loaded(residence):
            return residence
        }
      },
      as: TypeReference<FriendResidence>.self)
  }
}
