import DuetSQL
import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidenceDuration(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .queryEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.find(FriendResidenceDuration.self, byId: args.id)
    }
  }

  func getFriendResidenceDurations(
    req: Req,
    args: NoArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.query(FriendResidenceDuration.self).all()
    }
  }

  func createFriendResidenceDuration(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendResidenceDurationInput>
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      let friendResidenceDuration = FriendResidenceDuration(args.input)
      guard friendResidenceDuration.isValid else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(friendResidenceDuration)
      return try await Current.db.find(created.id)
    }
  }

  func createFriendResidenceDurations(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendResidenceDurationInput]>
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      let friendResidenceDurations = args.input.map(FriendResidenceDuration.init)
      guard friendResidenceDurations.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(friendResidenceDurations)
      return try await Current.db.query(FriendResidenceDuration.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateFriendResidenceDuration(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendResidenceDurationInput>
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      let friendResidenceDuration = FriendResidenceDuration(args.input)
      guard friendResidenceDuration.isValid else { throw ModelError.invalidEntity }
      try await Current.db.update(friendResidenceDuration)
      return try await Current.db.find(friendResidenceDuration.id)
    }
  }

  func updateFriendResidenceDurations(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendResidenceDurationInput]>
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      let friendResidenceDurations = args.input.map(FriendResidenceDuration.init)
      guard friendResidenceDurations.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.update(friendResidenceDurations)
      return try await Current.db.query(FriendResidenceDuration.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteFriendResidenceDuration(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.delete(FriendResidenceDuration.self, byId: args.id)
    }
  }
}
