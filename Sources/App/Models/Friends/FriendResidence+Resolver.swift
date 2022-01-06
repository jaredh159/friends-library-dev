import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidence(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .queryFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.getFriendResidence(.init(rawValue: args.id))
    }
  }

  func getFriendResidences(
    req: Req,
    args: NoArgs
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.getFriendResidences(nil)
    }
  }

  func createFriendResidence(
    req: Req,
    args: AppSchema.CreateFriendResidenceArgs
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.createFriendResidence(FriendResidence(args.input))
    }
  }

  func createFriendResidences(
    req: Req,
    args: AppSchema.CreateFriendResidencesArgs
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.createFriendResidences(args.input.map(FriendResidence.init))
    }
  }

  func updateFriendResidence(
    req: Req,
    args: AppSchema.UpdateFriendResidenceArgs
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.updateFriendResidence(FriendResidence(args.input))
    }
  }

  func updateFriendResidences(
    req: Req,
    args: AppSchema.UpdateFriendResidencesArgs
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.updateFriendResidences(args.input.map(FriendResidence.init))
    }
  }

  func deleteFriendResidence(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.deleteFriendResidence(.init(rawValue: args.id))
    }
  }
}
