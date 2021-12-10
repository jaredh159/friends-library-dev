import FluentSQL
import Vapor

struct TokenRepository {
  var db: SQLDatabase

  func createToken(_ token: Token) throws -> Future<Void> {
    db.raw(
      """
      INSERT INTO \(table: Token.self)
      (
        \(col: Token[.id]),
        \(col: Token[.value]),
        \(col: Token[.description]),
        \(col: Token[.createdAt])
      ) VALUES (
        '\(id: token.id)',
        '\(id: token.value)',
        '\(raw: token.description)',
        current_timestamp
      )
      """
    ).all().map { _ in }
  }

  func getTokenByValue(_ value: Token.Value) throws -> Future<Token> {
    db.raw(
      """
      SELECT * FROM \(table: Token.self)
      WHERE "\(col: Token[.value])" = '\(id: value)'
      """
    ).all().map { rows -> Token in
      let row = rows.first!
      return try! row.decode(Token.self)
    }.flatMap { token in
      try! Current.db.getTokenScopes(token.id).map { scopes in
        (token, scopes)
      }
    }.map { (token, scopes) in
      token.scopes = .loaded(scopes)
      return token
    }
  }

  func createTokenScope(_ scope: TokenScope) throws -> Future<Void> {
    db.raw(
      """
      INSERT INTO \(table: TokenScope.self)
      (
        \(col: TokenScope[.id]),
        \(col: TokenScope[.tokenId]),
        \(col: TokenScope[.scope]),
        \(col: TokenScope[.createdAt])
      ) VALUES (
        '\(id: scope.id)',
        '\(id: scope.tokenId)',
        '\(raw: scope.scope.rawValue)',
        current_timestamp
      )
      """
    ).all().map { _ in }
  }

  func getTokenScopes(_ tokenId: Token.Id) throws -> Future<[TokenScope]> {
    db.raw(
      """
      SELECT * FROM \(table: TokenScope.self)
      WHERE \(col: TokenScope[.tokenId]) = '\(id: tokenId)'
      """
    ).all().flatMapThrowing { rows in
      try rows.compactMap { row in
        try row.decode(
          model: TokenScope.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
      }
    }
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
