import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: Alt.Token.Value
  }

  func getTokenByValue(request: Request, args: GetTokenByValueArgs) throws -> Future<Alt.Token> {
    try Current.db.getTokenByValue(args.value)
  }
}
