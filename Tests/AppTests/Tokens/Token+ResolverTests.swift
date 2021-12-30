import XCTVapor
import XCTVaporUtils

@testable import App

final class TokenResolverTests: AppTestCase {

  func testTokenByValue() async throws {
    let token = Token(description: "test")
    _ = try await Current.db.createToken(token)
    let scope = TokenScope(tokenId: token.id, scope: .queryOrders)
    _ = try await Current.db.createTokenScope(scope)

    GraphQLTest(
      """
      query {
        getTokenByValue(value: "\(token.value.uuidString)") {
          id
          value
          description
          #scopes {
            #scope
          #}
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": token.id.uuidString,
        "value": token.value.uuidString,
        "description": "test",
          // "scope": "queryOrders",
      ])
    ).run(Self.app)
  }
}
