import XCTest

@testable import App

final class TokenResolverTests: AppTestCase {

  func testTokenByValue() async throws {
    let token = Token(description: "test")
    try await Current.db.create(token)
    let scope = TokenScope(tokenId: token.id, scope: .queryOrders)
    try await Current.db.create(scope)

    assertResponse(
      to: /* gql */ """
      query {
        getTokenByValue(value: "\(token.value.lowercased)") {
          id
          value
          description
          scopes {
            scope
            token {
              scopeTokenId: id
            }
          }
        }
      }
      """,
      .containsKeyValuePairs([
        "id": token.id.lowercased,
        "scopeTokenId": token.id.lowercased,
        "value": token.value.lowercased,
        "description": "test",
        "scope": "queryOrders",
      ])
    )
  }
}
