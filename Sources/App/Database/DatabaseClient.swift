import Fluent
import FluentSQL
import Tagged
import Vapor

struct DatabaseClient {
  var createToken: (Token) throws -> Future<Void>
  var getTokenByValue: (Token.Value) throws -> Future<Token>
  var createTokenScope: (TokenScope) throws -> Future<Void>
  var getTokenScopes: (Token.Id) throws -> Future<[TokenScope]>
}

extension DatabaseClient {
  static let throwing = DatabaseClient(
    createToken: { _ in throw Abort(.notImplemented) },
    getTokenByValue: { _ in throw Abort(.notImplemented) },
    createTokenScope: { _ in throw Abort(.notImplemented) },
    getTokenScopes: { _ in throw Abort(.notImplemented) }
  )
}

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client = DatabaseClient.throwing
    TokenRepository(db: db).assign(client: &client)
    return client
  }
}

extension DatabaseClient {
  static func mock(el: EventLoop) -> DatabaseClient {
    let mockDb = MockDb()
    var client = DatabaseClient.throwing
    MockTokenRepository(db: mockDb, eventLoop: el).assign(client: &client)
    return client
  }
}
