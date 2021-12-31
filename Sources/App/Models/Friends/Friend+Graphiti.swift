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
      at: resolveChildren { friend, eventLoop -> Future<[Document]> in
        switch friend.documents {
          case .notLoaded:
            return future(of: [Document].self, on: eventLoop) {
              fatalError("not implemented")
            }
          case let .loaded(friendChildren):
            return eventLoop.makeSucceededFuture(friendChildren)
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
      at: resolveChildren { friend, eventLoop -> Future<[FriendResidence]> in
        switch friend.residences {
          case .notLoaded:
            return future(of: [FriendResidence].self, on: eventLoop) {
              fatalError("not implemented")
            }
          case let .loaded(friendChildren):
            return eventLoop.makeSucceededFuture(friendChildren)
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
      at: resolveChildren { friend, eventLoop -> Future<[FriendQuote]> in
        switch friend.quotes {
          case .notLoaded:
            return future(of: [FriendQuote].self, on: eventLoop) {
              fatalError("not implemented")
            }
          case let .loaded(friendChildren):
            return eventLoop.makeSucceededFuture(friendChildren)
        }
      },
      as: [TypeRef<FriendQuote>].self)
  }
}
