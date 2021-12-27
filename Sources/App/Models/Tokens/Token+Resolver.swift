import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: Token.Value
  }

  func getTokenByValue(req: Req, args: GetTokenByValueArgs) throws -> Future<Token> {
    let promise = req.eventLoop.makePromise(of: Token.self)
    promise.completeWithTask { try await Current.db.getTokenByValue(args.value) }
    return promise.futureResult
  }
}
