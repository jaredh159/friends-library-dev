import GraphQLKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class TokenResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testTokenByValue() throws {
    Current.db = .mock(el: app.db.eventLoop)
    print(1)
    let token = Token(description: "test")
    print(2)
    _ = try Current.db.createToken(token).wait()
    print(3)
    // try token.create(on: app.db).wait()
    let scope = TokenScope(tokenId: token.id!, scope: .queryOrders)
    print(4)
    _ = try Current.db.createTokenScope(scope).wait()
    print(5)

    GraphQLTest(
      """
      query {
        getTokenByValue(value: "\(token.value.uuidString)") {
          id
          value
          description
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": token.id!.uuidString,
        "value": token.value.uuidString,
        "description": "test",
          // "scope": "queryOrders",
      ])
    ).run(self)
  }
}
