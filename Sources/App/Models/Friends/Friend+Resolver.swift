import Vapor

// below auto-generated

extension Resolver {
  func getFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.getFriend(.init(rawValue: args.id))
    }
  }

  func getFriends(req: Req, args: NoArgs) throws -> Future<[Friend]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.getFriends()
    }
  }

  func createFriend(req: Req, args: AppSchema.CreateFriendArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.createFriend(Friend(args.input))
    }
  }

  func createFriends(req: Req, args: AppSchema.CreateFriendsArgs) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.createFriends(args.input.map(Friend.init))
    }
  }

  func updateFriend(req: Req, args: AppSchema.UpdateFriendArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.updateFriend(Friend(args.input))
    }
  }

  func updateFriends(req: Req, args: AppSchema.UpdateFriendsArgs) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.updateFriends(args.input.map(Friend.init))
    }
  }

  func deleteFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.deleteFriend(.init(rawValue: args.id))
    }
  }
}
