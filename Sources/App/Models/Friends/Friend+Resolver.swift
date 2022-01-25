import Vapor

// below auto-generated

extension Resolver {
  func getFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.find(Friend.self, byId: args.id)
    }
  }

  func getFriends(req: Req, args: NoArgs) throws -> Future<[Friend]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.query(Friend.self).all()
    }
  }

  func createFriend(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendInput>
  ) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.create(Friend(args.input))
    }
  }

  func createFriends(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendInput]>
  ) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Friend.init))
    }
  }

  func updateFriend(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendInput>
  ) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.update(Friend(args.input))
    }
  }

  func updateFriends(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendInput]>
  ) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Friend.init))
    }
  }

  func deleteFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.delete(Friend.self, byId: args.id)
    }
  }
}
