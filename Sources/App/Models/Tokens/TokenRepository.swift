import FluentSQL
import Vapor

struct TokenRepository {
  var db: SQLDatabase

  func createToken(_ token: Token) throws -> Future<Void> {
    return try insert(
      into: Token.tableName,
      values: [
        Token[.id]: .id(token),
        Token[.value]: .uuid(token.value),
        Token[.description]: .string(token.description),
        Token[.createdAt]: .currentTimestamp,
      ])
  }

  func getTokenByValue(_ value: Token.Value) throws -> Future<Token> {
    return try select(.all, from: Token.self, where: (Token[.value], .equals, .uuid(value)))
      .flatMapThrowing { tokens in
        guard let token = tokens.first else { throw DbError.notFound }
        return token
      }.flatMapThrowing { token in
        try Current.db.getTokenScopes(token.id).map { scopes in
          (token, scopes)
        }
      }.flatMap { future in
        future
      }.flatMap {
        (token: Token, scopes: [TokenScope]) -> Future<Token> in
        token.scopes = .loaded(scopes)
        return db.eventLoop.makeSucceededFuture(token)
      }
  }

  func createTokenScope(_ scope: TokenScope) throws -> Future<Void> {
    return try insert(
      into: TokenScope.tableName,
      values: [
        TokenScope[.id]: .id(scope),
        TokenScope[.tokenId]: .uuid(scope.tokenId),
        TokenScope[.scope]: .enum(scope.scope),
        TokenScope[.createdAt]: .currentTimestamp,
      ])
  }

  func getTokenScopes(_ tokenId: Token.Id) throws -> Future<[TokenScope]> {
    return try select(
      .all,
      from: TokenScope.self,
      where: (TokenScope[.tokenId], .equals, .uuid(tokenId))
    )
  }
}

struct MockTokenRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func createToken(_ token: Token) throws -> Future<Void> {
    future(db.add(token, to: \.tokens))
  }

  func getTokenByValue(_ value: Token.Value) throws -> Future<Token> {
    try future(db.first(where: { $0.value == value }, in: \.tokens))
  }

  func createTokenScope(_ scope: TokenScope) throws -> Future<Void> {
    future(db.add(scope, to: \.tokenScopes))
  }

  func getTokenScopes(_ tokenId: Token.Id) throws -> Future<[TokenScope]> {
    future(db.tokenScopes.values.filter { $0.tokenId == tokenId })
  }
}

/// extensions

extension TokenRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createToken = { try createToken($0) }
    client.createTokenScope = { try createTokenScope($0) }
    client.getTokenByValue = { try getTokenByValue($0) }
    client.getTokenScopes = { try getTokenScopes($0) }
  }
}

extension MockTokenRepository: MockRepository {
  func assign(client: inout DatabaseClient) {
    client.createToken = { try createToken($0) }
    client.createTokenScope = { try createTokenScope($0) }
    client.getTokenByValue = { try getTokenByValue($0) }
    client.getTokenScopes = { try getTokenScopes($0) }
  }
}
