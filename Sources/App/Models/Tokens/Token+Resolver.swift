import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: Token.Value
  }

  func getTokenByValue(_: Req, args: GetTokenByValueArgs) throws -> Future<Token> {
    try Current.db.getTokenByValue(args.value)
  }
}
