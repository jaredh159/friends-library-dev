import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: FriendResidence {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<FriendResidenceDuration>
  ) where FieldType == [TypeRef<FriendResidenceDuration>] {
    self.init(
      name.description,
      at: resolveChildren { (friendResidence) async throws -> [FriendResidenceDuration] in
        switch friendResidence.durations {
          case .notLoaded:
            fatalError("FriendResidence -> Children<[FriendResidenceDuration]> not implemented")
          case let .loaded(friendResidenceChildren):
            return friendResidenceChildren
        }
      },
      as: [TypeRef<FriendResidenceDuration>].self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: FriendResidence {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Friend>
  ) where FieldType == TypeRef<Friend> {
    self.init(
      name.description,
      at: resolveParent { (friendResidence) async throws -> Friend in
        switch friendResidence.friend {
          case .notLoaded:
            fatalError("FriendResidence -> Parent<Friend> not implemented")
          case let .loaded(friend):
            return friend
        }
      },
      as: TypeReference<Friend>.self)
  }
}
