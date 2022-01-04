import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendQuoteResolverTests: AppTestCase {

  func testCreateFriendQuote() async throws {
    let friendQuote = FriendQuote.random
    let map = friendQuote.gqlMap()

    GraphQLTest(
      """
      mutation CreateFriendQuote($input: CreateFriendQuoteInput!) {
        download: createFriendQuote(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetFriendQuote() async throws {
    let friendQuote = try await Current.db.createFriendQuote(.random)

    GraphQLTest(
      """
      query GetFriendQuote {
        friendQuote: getFriendQuote(id: "\(friendQuote.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friendQuote.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateFriendQuote() async throws {
    let friendQuote = try await Current.db.createFriendQuote(.random)

    // do some updates here ---vvv
    friendQuote.source = "new value"

    GraphQLTest(
      """
      mutation UpdateFriendQuote($input: UpdateFriendQuoteInput!) {
        friendQuote: updateFriendQuote(input: $input) {
          source
        }
      }
      """,
      expectedData: .containsKVPs(["source": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friendQuote.gqlMap()])
  }

  func testDeleteFriendQuote() async throws {
    let friendQuote = try await Current.db.createFriendQuote(.random)

    GraphQLTest(
      """
      mutation DeleteFriendQuote {
        friendQuote: deleteFriendQuote(id: "\(friendQuote.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friendQuote.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friendQuote.gqlMap()])

    let retrieved = try? await Current.db.getFriendQuote(friendQuote.id)
    XCTAssertNil(retrieved)
  }
}
