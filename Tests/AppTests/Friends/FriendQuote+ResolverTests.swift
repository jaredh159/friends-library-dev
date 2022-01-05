import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendQuoteResolverTests: AppTestCase {

  func testCreateFriendQuote() async throws {
    let entities = await Entities.create()
    let friendQuote = FriendQuote.random
    friendQuote.friendId = entities.friend.id
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
    let friendQuote = await Entities.create().friendQuote

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
    let friendQuote = await Entities.create().friendQuote

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
    let friendQuote = await Entities.create().friendQuote

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
