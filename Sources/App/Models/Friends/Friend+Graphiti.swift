import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Friend {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<Document>
  ) where FieldType == [TypeRef<Document>] {
    self.init(
      name.description,
      at: resolveChildren { (friend) async throws -> [Document] in
        switch friend.documents {
          case .notLoaded:
            return try await Current.db.getFriendDocuments(friend.id)
          case let .loaded(friendChildren):
            return friendChildren
        }
      },
      as: [TypeRef<Document>].self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Friend {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<FriendResidence>
  ) where FieldType == [TypeRef<FriendResidence>] {
    self.init(
      name.description,
      at: resolveChildren { (friend) async throws -> [FriendResidence] in
        switch friend.residences {
          case .notLoaded:
            fatalError("not implemented")
          case let .loaded(friendChildren):
            return friendChildren
        }
      },
      as: [TypeRef<FriendResidence>].self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Friend {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<FriendQuote>
  ) where FieldType == [TypeRef<FriendQuote>] {
    self.init(
      name.description,
      at: resolveChildren { (friend) async throws -> [FriendQuote] in
        switch friend.quotes {
          case .notLoaded:
            fatalError("not implemented")
          case let .loaded(friendChildren):
            return friendChildren
        }
      },
      as: [TypeRef<FriendQuote>].self)
  }
}
