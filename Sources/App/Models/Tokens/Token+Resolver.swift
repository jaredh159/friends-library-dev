import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: Token.Value
  }

  func getTokenByValue(req: Req, args: GetTokenByValueArgs) throws -> Future<Token> {
    future(of: Token.self, on: req.eventLoop) {
      try await Current.db.getTokenByValue(args.value)
    }
  }
}


// below auto-generated
extension Resolver {
  func getToken(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Token> {
    throw Abort(.notImplemented)
  }

  func getTokens(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Token]> {
    throw Abort(.notImplemented)
  }

  func createToken(
    req: Req,
    args: Token.GraphQL.Request.Args.Create
  ) throws -> Future<Token> {
    throw Abort(.notImplemented)
  }

  func createTokens(
    req: Req,
    args: Token.GraphQL.Request.Args.CreateMany
  ) throws -> Future<[Token]> {
    throw Abort(.notImplemented)
  }

  func updateToken(
    req: Req,
    args: Token.GraphQL.Request.Args.Update
  ) throws -> Future<Token> {
    throw Abort(.notImplemented)
  }

  func updateTokens(
    req: Req,
    args: Token.GraphQL.Request.Args.UpdateMany
  ) throws -> Future<[Token]> {
    throw Abort(.notImplemented)
  }

  func deleteToken(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Token> {
    throw Abort(.notImplemented)
  }
}
