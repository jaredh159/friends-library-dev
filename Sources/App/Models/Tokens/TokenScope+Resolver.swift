import Vapor

// below auto-generated

extension Resolver {
  func getTokenScope(req: Req, args: IdentifyEntityArgs) throws -> Future<TokenScope> {
    try req.requirePermission(to: .queryFriends)
    return future(of: TokenScope.self, on: req.eventLoop) {
      try await Current.db.find(TokenScope.self, byId: args.id)
    }
  }

  func getTokenScopes(req: Req, args: NoArgs) throws -> Future<[TokenScope]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [TokenScope].self, on: req.eventLoop) {
      try await Current.db.query(TokenScope.self).all()
    }
  }

  func createTokenScope(
    req: Req,
    args: InputArgs<AppSchema.CreateTokenScopeInput>
  ) throws -> Future<TokenScope> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: TokenScope.self, on: req.eventLoop) {
      try await Current.db.create(TokenScope(args.input))
    }
  }

  func createTokenScopes(
    req: Req,
    args: InputArgs<[AppSchema.CreateTokenScopeInput]>
  ) throws -> Future<[TokenScope]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [TokenScope].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(TokenScope.init))
    }
  }

  func updateTokenScope(
    req: Req,
    args: InputArgs<AppSchema.UpdateTokenScopeInput>
  ) throws -> Future<TokenScope> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: TokenScope.self, on: req.eventLoop) {
      try await Current.db.update(TokenScope(args.input))
    }
  }

  func updateTokenScopes(
    req: Req,
    args: InputArgs<[AppSchema.UpdateTokenScopeInput]>
  ) throws -> Future<[TokenScope]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [TokenScope].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(TokenScope.init))
    }
  }

  func deleteTokenScope(req: Req, args: IdentifyEntityArgs) throws -> Future<TokenScope> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: TokenScope.self, on: req.eventLoop) {
      try await Current.db.delete(TokenScope.self, byId: args.id)
    }
  }
}
