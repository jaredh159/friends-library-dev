import Vapor

// below auto-generated

extension Resolver {
  func getFriendQuote(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .queryEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.find(FriendQuote.self, byId: args.id)
    }
  }

  func getFriendQuotes(req: Req, args: NoArgs) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      try await Current.db.query(FriendQuote.self).all()
    }
  }

  func createFriendQuote(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendQuoteInput>
  ) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      let friendQuote = FriendQuote(args.input)
      guard friendQuote.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(friendQuote)
      return try await Current.db.find(created.id)
    }
  }

  func createFriendQuotes(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendQuoteInput]>
  ) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      let friendQuotes = args.input.map(FriendQuote.init)
      guard friendQuotes.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(friendQuotes)
      return try await Current.db.query(FriendQuote.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateFriendQuote(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendQuoteInput>
  ) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      let friendQuote = FriendQuote(args.input)
      guard friendQuote.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(friendQuote)
      return try await Current.db.find(friendQuote.id)
    }
  }

  func updateFriendQuotes(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendQuoteInput]>
  ) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      let friendQuotes = args.input.map(FriendQuote.init)
      guard friendQuotes.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(friendQuotes)
      return try await Current.db.query(FriendQuote.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteFriendQuote(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.delete(FriendQuote.self, byId: args.id)
    }
  }
}
