import Vapor

extension Resolver {
  func getFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.getFriend(.init(rawValue: args.id))
    }
  }

  func createFriend(req: Req, args: AppSchema.CreateFriendArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.createFriend(Friend(args.input))
    }
  }

  func updateFriend(req: Req, args: AppSchema.UpdateFriendArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      return try await Current.db.updateFriend(Friend(args.input))
    }
  }

  func deleteFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      let friend = try await Current.db.getFriend(.init(rawValue: args.id))
      try await Current.db.deleteFriend(friend.id)
      return friend
    }
  }
}

// below auto-generated

extension Resolver {

  func getFriends(req: Req, args: NoArgs) throws -> Future<[Friend]> {
    throw Abort(.notImplemented, reason: "Resolver.getFriends")
  }

  func createFriends(req: Req, args: AppSchema.CreateFriendsArgs) throws -> Future<[Friend]> {
    throw Abort(.notImplemented, reason: "Resolver.createFriends")
  }

  func updateFriends(req: Req, args: AppSchema.UpdateFriendsArgs) throws -> Future<[Friend]> {
    throw Abort(.notImplemented, reason: "Resolver.updateFriends")
  }
}
