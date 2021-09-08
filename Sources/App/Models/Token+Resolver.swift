import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: UUID
  }

  func getTokenByValue(
    request: Request,
    args: GetTokenByValueArgs
  ) throws -> Future<Token> {
    Token.query(on: request.db)
      .filter(\.$value == args.value)
      .with(\.$scopes)
      .first()
      .unwrap(or: Abort(.notFound))
  }
}
