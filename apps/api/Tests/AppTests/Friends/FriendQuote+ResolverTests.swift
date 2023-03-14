import XCTest

@testable import App

final class FriendQuoteResolverTests: AppTestCase {

  func testCreateFriendQuote() async throws {
    let entities = await Entities.create()
    let friendQuote = FriendQuote.valid
    friendQuote.friendId = entities.friend.id
    let map = friendQuote.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateFriendQuote($input: CreateFriendQuoteInput!) {
        friendQuote: createFriendQuote(input: $input) {
          id
        }
      }
      """,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetFriendQuote() async throws {
    let friendQuote = await Entities.create().friendQuote

    assertResponse(
      to: /* gql */ """
      query GetFriendQuote {
        friendQuote: getFriendQuote(id: "\(friendQuote.id.uuidString)") {
          id
        }
      }
      """,
      .containsKeyValuePairs(["id": friendQuote.id.lowercased])
    )
  }

  func testUpdateFriendQuote() async throws {
    let friendQuote = await Entities.create().friendQuote

    // do some updates here ---vvv
    friendQuote.source = "New value"

    assertResponse(
      to: /* gql */ """
      mutation UpdateFriendQuote($input: UpdateFriendQuoteInput!) {
        friendQuote: updateFriendQuote(input: $input) {
          source
        }
      }
      """,
      withVariables: ["input": friendQuote.gqlMap()],
      .containsKeyValuePairs(["source": "New value"])
    )
  }

  func testDeleteFriendQuote() async throws {
    let friendQuote = await Entities.create().friendQuote

    assertResponse(
      to: /* gql */ """
      mutation DeleteFriendQuote {
        friendQuote: deleteFriendQuote(id: "\(friendQuote.id.uuidString)") {
          id
        }
      }
      """,
      withVariables: ["input": friendQuote.gqlMap()],
      .containsKeyValuePairs(["id": friendQuote.id.lowercased])
    )

    let retrieved = try? await Current.db.find(friendQuote.id)
    XCTAssertNil(retrieved)
  }
}
