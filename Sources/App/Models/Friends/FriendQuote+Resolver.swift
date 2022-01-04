import Vapor

// below auto-generated

extension Resolver {
  func getFriendQuote(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .queryFriends)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.getFriendQuote(.init(rawValue: args.id))
    }
  }

  func getFriendQuotes(req: Req, args: NoArgs) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      try await Current.db.getFriendQuotes()
    }
  }

  func createFriendQuote(
    req: Req,
    args: AppSchema.CreateFriendQuoteArgs
  ) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.createFriendQuote(FriendQuote(args.input))
    }
  }

  func createFriendQuotes(
    req: Req,
    args: AppSchema.CreateFriendQuotesArgs
  ) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      try await Current.db.createFriendQuotes(args.input.map(FriendQuote.init))
    }
  }

  func updateFriendQuote(
    req: Req,
    args: AppSchema.UpdateFriendQuoteArgs
  ) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.updateFriendQuote(FriendQuote(args.input))
    }
  }

  func updateFriendQuotes(
    req: Req,
    args: AppSchema.UpdateFriendQuotesArgs
  ) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      try await Current.db.updateFriendQuotes(args.input.map(FriendQuote.init))
    }
  }

  func deleteFriendQuote(req: Req, args: IdentifyEntityArgs) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.deleteFriendQuote(.init(rawValue: args.id))
    }
  }
}
