import XCTVapor
import XCTVaporUtils

@testable import App

final class TokenResolverTests: AppTestCase {

  func testTokenByValue() throws {
    let token = Token(description: "test")
    _ = try Current.db.createToken(token).wait()
    let scope = TokenScope(tokenId: token.id, scope: .queryOrders)
    _ = try Current.db.createTokenScope(scope).wait()

    GraphQLTest(
      """
      query {
        getTokenByValue(value: "\(token.value.uuidString)") {
          id
          value
          description
          scopes {
            scope
          }
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": token.id.uuidString,
        "value": token.value.uuidString,
        "description": "test",
        "scope": "queryOrders",
      ])
    ).run(Self.app)
  }
}
