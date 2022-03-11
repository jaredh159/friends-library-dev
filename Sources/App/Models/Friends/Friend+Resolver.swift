import Vapor

// below auto-generated

extension Resolver {
  func getFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.find(Friend.self, byId: args.id)
    }
  }

  func getFriends(req: Req, args: NoArgs) throws -> Future<[Friend]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.query(Friend.self).all()
    }
  }

  func createFriend(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendInput>
  ) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      let friend = try Friend(args.input)
      guard friend.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(friend)
      return try await Current.db.find(created.id)
    }
  }

  func createFriends(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendInput]>
  ) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Friend].self, on: req.eventLoop) {
      let friends = try args.input.map(Friend.init)
      guard friends.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(friends)
      return try await Current.db.query(Friend.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateFriend(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendInput>
  ) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      let friend = try Friend(args.input)
      guard friend.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(friend)
      return try await Current.db.find(friend.id)
    }
  }

  func updateFriends(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendInput]>
  ) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Friend].self, on: req.eventLoop) {
      let friends = try args.input.map(Friend.init)
      guard friends.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(friends)
      return try await Current.db.query(Friend.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteFriend(req: Req, args: IdentifyEntityArgs) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.delete(Friend.self, byId: args.id)
    }
  }
}
