import FluentSQL
import Vapor

struct TokenRepository {
  var db: SQLDatabase

  func createToken(_ token: Token) async throws {
    try await insert(token)
  }

  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    let token = try await select(
      .all,
      from: Token.self,
      where: (Token[.value], .equals, .uuid(value))
    ).firstOrThrowNotFound()

    let scopes = try await getTokenScopes(token.id)
    token.scopes = .loaded(scopes)
    return token
  }

  func createTokenScope(_ scope: TokenScope) async throws {
    try await insert(scope)
  }

  func getTokenScopes(_ tokenId: Token.Id) async throws -> [TokenScope] {
    try await select(
      .all,
      from: TokenScope.self,
      where: (TokenScope[.tokenId], .equals, .uuid(tokenId))
    )
  }
}

struct MockTokenRepository {
  var db: MockDb

  func createToken(_ token: Token) async throws {
    db.add(token, to: \.tokens)
  }

  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    try db.first(where: { $0.value == value }, in: \.tokens)
  }

  func createTokenScope(_ scope: TokenScope) async throws {
    db.add(scope, to: \.tokenScopes)
  }

  func getTokenScopes(_ tokenId: Token.Id) async throws -> [TokenScope] {
    db.tokenScopes.values.filter { $0.tokenId == tokenId }
  }
}

/// extensions

extension TokenRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createToken = { try await createToken($0) }
    client.createTokenScope = { try await createTokenScope($0) }
    client.getTokenByValue = { try await getTokenByValue($0) }
    client.getTokenScopes = { try await getTokenScopes($0) }
  }
}

extension MockTokenRepository: MockRepository {
  func assign(client: inout DatabaseClient) {
    client.createToken = { try await createToken($0) }
    client.createTokenScope = { try await createTokenScope($0) }
    client.getTokenByValue = { try await getTokenByValue($0) }
    client.getTokenScopes = { try await getTokenScopes($0) }
  }
}
