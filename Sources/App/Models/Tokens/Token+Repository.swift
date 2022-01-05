import FluentSQL
import Vapor

extension Repository where Model == Token {
  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    let token = try await findAll(where: (Token[.value], .equals, .uuid(value)))
      .firstOrThrowNotFound()
    let scopes = try await getTokenScopes(token.id)
    token.scopes = .loaded(scopes)
    return token
  }

  func getTokenScopes(_ tokenId: Token.Id) async throws -> [TokenScope] {
    try await selectRelation(
      from: TokenScope.self,
      where: (TokenScope[.tokenId], .equals, .uuid(tokenId))
    )
  }

  func assign(client: inout DatabaseClient) {
    // client.createTokenScope = { try await createTokenScope($0) }
    client.getTokenByValue = { try await getTokenByValue($0) }
    client.getTokenTokenScopes = { try await getTokenScopes($0) }
  }
}

extension MockRepository where Model == Token {
  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    try await findAll(where: { $0.value == value }).firstOrThrowNotFound()
  }

  func createTokenScope(_ scope: TokenScope) async throws -> TokenScope {
    db.add(scope, to: \.tokenScopes)
  }

  func getTokenScopes(_ tokenId: Token.Id) async throws -> [TokenScope] {
    db.find(where: { $0.tokenId == tokenId }, in: \.tokenScopes)
  }

  func assign(client: inout DatabaseClient) {
    // client.createTokenScope = { try await createTokenScope($0) }
    client.getTokenByValue = { try await getTokenByValue($0) }
    client.getTokenTokenScopes = { try await getTokenScopes($0) }
  }
}
