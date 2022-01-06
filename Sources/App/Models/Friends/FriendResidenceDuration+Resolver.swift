import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidenceDuration(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .queryFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.getFriendResidenceDuration(.init(rawValue: args.id))
    }
  }

  func getFriendResidenceDurations(
    req: Req,
    args: NoArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.getFriendResidenceDurations(nil)
    }
  }

  func createFriendResidenceDuration(
    req: Req,
    args: AppSchema.CreateFriendResidenceDurationArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.createFriendResidenceDuration(FriendResidenceDuration(args.input))
    }
  }

  func createFriendResidenceDurations(
    req: Req,
    args: AppSchema.CreateFriendResidenceDurationsArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.createFriendResidenceDurations(
        args.input.map(FriendResidenceDuration.init))
    }
  }

  func updateFriendResidenceDuration(
    req: Req,
    args: AppSchema.UpdateFriendResidenceDurationArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.updateFriendResidenceDuration(FriendResidenceDuration(args.input))
    }
  }

  func updateFriendResidenceDurations(
    req: Req,
    args: AppSchema.UpdateFriendResidenceDurationsArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.updateFriendResidenceDurations(
        args.input.map(FriendResidenceDuration.init))
    }
  }

  func deleteFriendResidenceDuration(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.deleteFriendResidenceDuration(.init(rawValue: args.id))
    }
  }
}
