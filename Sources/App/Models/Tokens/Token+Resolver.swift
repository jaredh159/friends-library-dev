import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: UUID
  }

  func getTokenByValue(req: Req, args: GetTokenByValueArgs) throws -> Future<Token> {
    future(of: Token.self, on: req.eventLoop) {
      try await Current.db.getTokenByValue(.init(rawValue: args.value))
    }
  }
}

// below auto-generated

extension Resolver {
  func getToken(req: Req, args: IdentifyEntityArgs) throws -> Future<Token> {
    throw Abort(.notImplemented, reason: "db.getToken")
  }

  func getTokens(req: Req, args: NoArgs) throws -> Future<[Token]> {
    throw Abort(.notImplemented, reason: "db.getTokens")
  }

  func createToken(req: Req, args: AppSchema.CreateTokenArgs) throws -> Future<Token> {
    throw Abort(.notImplemented, reason: "db.createToken")
  }

  func createTokens(req: Req, args: AppSchema.CreateTokensArgs) throws -> Future<[Token]> {
    throw Abort(.notImplemented, reason: "db.createTokens")
  }

  func updateToken(req: Req, args: AppSchema.UpdateTokenArgs) throws -> Future<Token> {
    throw Abort(.notImplemented, reason: "db.updateToken")
  }

  func updateTokens(req: Req, args: AppSchema.UpdateTokensArgs) throws -> Future<[Token]> {
    throw Abort(.notImplemented, reason: "db.updateTokens")
  }

  func deleteToken(req: Req, args: IdentifyEntityArgs) throws -> Future<Token> {
    throw Abort(.notImplemented, reason: "db.deleteToken")
  }
}
