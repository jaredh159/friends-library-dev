// import GraphQlKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class TokenResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testTokenByValue() throws {
    // Current.db = .mock(el: app.db.eventLoop)
    let token = Alt.Token(description: "test")
    _ = try Current.db.createToken(token).wait()
    let scope = Alt.TokenScope(tokenId: token.id, scope: .queryOrders)
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
    ).run(self)
  }
}
