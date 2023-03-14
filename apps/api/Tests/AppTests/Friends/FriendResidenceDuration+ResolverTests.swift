import XCTest

@testable import App

final class FriendResidenceDurationResolverTests: AppTestCase {

  func testCreateFriendResidenceDuration() async throws {
    let friendResidence = await Entities.create().friendResidence
    let friendResidenceDuration: FriendResidenceDuration = .valid
    friendResidenceDuration.friendResidenceId = friendResidence.id
    let map = friendResidenceDuration.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateFriendResidenceDuration($input: CreateFriendResidenceDurationInput!) {
        friendResidenceDuration: createFriendResidenceDuration(input: $input) {
          id
        }
      }
      """,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetFriendResidenceDuration() async throws {
    let friendResidenceDuration = await Entities.create().friendResidenceDuration

    assertResponse(
      to: /* gql */ """
      query GetFriendResidenceDuration {
        friendResidenceDuration: getFriendResidenceDuration(id: "\(friendResidenceDuration.id
        .uuidString)") {
          id
        }
      }
      """,
      .containsKeyValuePairs(["id": friendResidenceDuration.id.lowercased])
    )
  }

  func testUpdateFriendResidenceDuration() async throws {
    let friendResidenceDuration = await Entities.create().friendResidenceDuration

    // do some updates here ---vvv
    friendResidenceDuration.start = 1620
    friendResidenceDuration.end = 1630

    assertResponse(
      to: /* gql */ """
      mutation UpdateFriendResidenceDuration($input: UpdateFriendResidenceDurationInput!) {
        friendResidenceDuration: updateFriendResidenceDuration(input: $input) {
          start
        }
      }
      """,
      withVariables: ["input": friendResidenceDuration.gqlMap()],
      .containsKeyValuePairs(["start": 1620])
    )
  }

  func testDeleteFriendResidenceDuration() async throws {
    let friendResidenceDuration = await Entities.create().friendResidenceDuration

    assertResponse(
      to: /* gql */ """
      mutation DeleteFriendResidenceDuration {
        friendResidenceDuration: deleteFriendResidenceDuration(id: "\(friendResidenceDuration.id
        .uuidString)") {
          id
        }
      }
      """,
      withVariables: ["input": friendResidenceDuration.gqlMap()],
      .containsKeyValuePairs(["id": friendResidenceDuration.id.lowercased])
    )

    let retrieved = try? await Current.db.find(
      FriendResidenceDuration.self,
      byId: friendResidenceDuration.id
    )
    XCTAssertNil(retrieved)
  }
}
