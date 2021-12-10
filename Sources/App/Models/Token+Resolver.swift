import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: Token.Value
  }

  func getTokenByValue(request: Request, args: GetTokenByValueArgs) throws -> Future<Token> {
    try Current.db.getTokenByValue(args.value)
  }
}
