import XCTest

@testable import App

final class FriendResidenceResolverTests: AppTestCase {

  func testCreateFriendResidence() async throws {
    let friend = await Entities.create().friend
    let friendResidence = FriendResidence.random
    friendResidence.friendId = friend.id
    let map = friendResidence.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateFriendResidence($input: CreateFriendResidenceInput!) {
        friendResidence: createFriendResidence(input: $input) {
          id
        }
      }
      """,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetFriendResidence() async throws {
    let friendResidence = await Entities.create().friendResidence

    assertResponse(
      to: /* gql */ """
      query GetFriendResidence {
        friendResidence: getFriendResidence(id: "\(friendResidence.id.uuidString)") {
          id
        }
      }
      """,
      .containsKeyValuePairs(["id": friendResidence.id.lowercased])
    )
  }

  func testUpdateFriendResidence() async throws {
    let friendResidence = await Entities.create().friendResidence

    // do some updates here ---vvv
    friendResidence.city = "New value"

    assertResponse(
      to: /* gql */ """
      mutation UpdateFriendResidence($input: UpdateFriendResidenceInput!) {
        friendResidence: updateFriendResidence(input: $input) {
          city
        }
      }
      """,
      withVariables: ["input": friendResidence.gqlMap()],
      .containsKeyValuePairs(["city": "New value"])
    )
  }

  func testDeleteFriendResidence() async throws {
    let friendResidence = await Entities.create().friendResidence

    assertResponse(
      to: /* gql */ """
      mutation DeleteFriendResidence {
        friendResidence: deleteFriendResidence(id: "\(friendResidence.id.uuidString)") {
          id
        }
      }
      """,
      withVariables: ["input": friendResidence.gqlMap()],
      .containsKeyValuePairs(["id": friendResidence.id.lowercased])
    )

    let retrieved = try? await Current.db.find(friendResidence.id)
    XCTAssertNil(retrieved)
  }
}
