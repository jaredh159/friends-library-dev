import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: UUID
  }

  func getTokenByValue(req: Req, args: GetTokenByValueArgs) throws -> Future<Token> {
    future(of: Token.self, on: req.eventLoop) {
      try await Current.db.query(Token.self)
        .where(.value == args.value)
        .first()
    }
  }
}

// below auto-generated

extension Resolver {
  func getToken(req: Req, args: IdentifyEntityArgs) throws -> Future<Token> {
    try req.requirePermission(to: .queryTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.find(Token.self, byId: args.id)
    }
  }

  func getTokens(req: Req, args: NoArgs) throws -> Future<[Token]> {
    try req.requirePermission(to: .queryTokens)
    return future(of: [Token].self, on: req.eventLoop) {
      try await Current.db.query(Token.self).all()
    }
  }

  func createToken(
    req: Req,
    args: InputArgs<AppSchema.CreateTokenInput>
  ) throws -> Future<Token> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.create(Token(args.input))
    }
  }

  func createTokens(
    req: Req,
    args: InputArgs<[AppSchema.CreateTokenInput]>
  ) throws -> Future<[Token]> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: [Token].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Token.init))
    }
  }

  func updateToken(
    req: Req,
    args: InputArgs<AppSchema.UpdateTokenInput>
  ) throws -> Future<Token> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.update(Token(args.input))
    }
  }

  func updateTokens(
    req: Req,
    args: InputArgs<[AppSchema.UpdateTokenInput]>
  ) throws -> Future<[Token]> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: [Token].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Token.init))
    }
  }

  func deleteToken(req: Req, args: IdentifyEntityArgs) throws -> Future<Token> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.delete(Token.self, byId: args.id)
    }
  }
}
