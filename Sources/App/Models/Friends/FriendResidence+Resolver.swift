import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidence(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .queryEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.find(FriendResidence.self, byId: args.id)
    }
  }

  func getFriendResidences(req: Req, args: NoArgs) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.query(FriendResidence.self).all()
    }
  }

  func createFriendResidence(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendResidenceInput>
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      let friendResidence = FriendResidence(args.input)
      guard friendResidence.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(friendResidence)
      return try await Current.db.find(created.id)
    }
  }

  func createFriendResidences(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendResidenceInput]>
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      let friendResidences = args.input.map(FriendResidence.init)
      guard friendResidences.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(friendResidences)
      return try await Current.db.query(FriendResidence.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateFriendResidence(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendResidenceInput>
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      let friendResidence = FriendResidence(args.input)
      guard friendResidence.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(friendResidence)
      return try await Current.db.find(friendResidence.id)
    }
  }

  func updateFriendResidences(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendResidenceInput]>
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      let friendResidences = args.input.map(FriendResidence.init)
      guard friendResidences.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(friendResidences)
      return try await Current.db.query(FriendResidence.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteFriendResidence(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.delete(FriendResidence.self, byId: args.id)
    }
  }
}
