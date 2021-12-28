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
