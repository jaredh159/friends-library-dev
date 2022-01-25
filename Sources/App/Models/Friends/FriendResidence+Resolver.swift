import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidence(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .queryFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.find(FriendResidence.self, byId: args.id)
    }
  }

  func getFriendResidences(req: Req, args: NoArgs) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.query(FriendResidence.self).all()
    }
  }

  func createFriendResidence(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendResidenceInput>
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.create(FriendResidence(args.input))
    }
  }

  func createFriendResidences(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendResidenceInput]>
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(FriendResidence.init))
    }
  }

  func updateFriendResidence(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendResidenceInput>
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.update(FriendResidence(args.input))
    }
  }

  func updateFriendResidences(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendResidenceInput]>
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(FriendResidence.init))
    }
  }

  func deleteFriendResidence(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.delete(FriendResidence.self, byId: args.id)
    }
  }
}
