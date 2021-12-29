import FluentSQL
import Vapor

struct TokenRepository {
  var db: SQLDatabase

  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    let token = try await select(where: (Token[.value], .equals, .uuid(value)))
      .firstOrThrowNotFound()
    let scopes = try await getTokenScopes(token.id)
    token.scopes = .loaded(scopes)
    return token
  }

  func createTokenScope(_ scope: TokenScope) async throws {
    try await createRelation(scope)
  }

  func getTokenScopes(_ tokenId: Token.Id) async throws -> [TokenScope] {
    try await selectRelation(
      from: TokenScope.self,
      where: (TokenScope[.tokenId], .equals, .uuid(tokenId))
    )
  }
}

struct MockTokenRepository {
  var db: MockDb

  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    try await select(where: { $0.value == value }).firstOrThrowNotFound()
  }

  func createTokenScope(_ scope: TokenScope) async throws {
    db.add(scope, to: \.tokenScopes)
  }

  func getTokenScopes(_ tokenId: Token.Id) async throws -> [TokenScope] {
    db.find(where: { $0.tokenId == tokenId }, in: \.tokenScopes)
  }
}

/// extensions

extension TokenRepository: LiveRepository {
  typealias Model = Token

  func assign(client: inout DatabaseClient) {
    client.createToken = { try await create($0) }
    client.createTokenScope = { try await createTokenScope($0) }
    client.getTokenByValue = { try await getTokenByValue($0) }
    client.getTokenScopes = { try await getTokenScopes($0) }
  }
}

extension MockTokenRepository: MockRepository {
  typealias Model = Token
  var models: ModelsPath { \.tokens }

  func assign(client: inout DatabaseClient) {
    client.createToken = { try await create($0) }
    client.createTokenScope = { try await createTokenScope($0) }
    client.getTokenByValue = { try await getTokenByValue($0) }
    client.getTokenScopes = { try await getTokenScopes($0) }
  }
}
