import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidenceDuration(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .queryFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.find(FriendResidenceDuration.self, byId: args.id)
    }
  }

  func getFriendResidenceDurations(
    req: Req,
    args: NoArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.query(FriendResidenceDuration.self).all()
    }
  }

  func createFriendResidenceDuration(
    req: Req,
    args: AppSchema.CreateFriendResidenceDurationArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.create(FriendResidenceDuration(args.input))
    }
  }

  func createFriendResidenceDurations(
    req: Req,
    args: AppSchema.CreateFriendResidenceDurationsArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(FriendResidenceDuration.init))
    }
  }

  func updateFriendResidenceDuration(
    req: Req,
    args: AppSchema.UpdateFriendResidenceDurationArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.update(FriendResidenceDuration(args.input))
    }
  }

  func updateFriendResidenceDurations(
    req: Req,
    args: AppSchema.UpdateFriendResidenceDurationsArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(FriendResidenceDuration.init))
    }
  }

  func deleteFriendResidenceDuration(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.delete(FriendResidenceDuration.self, byId: args.id)
    }
  }
}
