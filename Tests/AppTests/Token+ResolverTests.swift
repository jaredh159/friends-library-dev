import GraphQLKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class TokenResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testTokenByValue() throws {
    let token = Token(description: "test")
    try token.create(on: app.db).wait()
    let scope = TokenScope(tokenId: token.id!, scope: .queryOrders)
    try scope.create(on: app.db).wait()

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
        "id": token.id!.uuidString,
        "value": token.value.uuidString,
        "description": "test",
        "scope": "queryOrders",
      ])
    ).run(self)
  }
}
