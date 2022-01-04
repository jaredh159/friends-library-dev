import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendResidenceDurationResolverTests: AppTestCase {

  func testCreateFriendResidenceDuration() async throws {
    let friendResidenceDuration = FriendResidenceDuration.random
    let map = friendResidenceDuration.gqlMap()

    GraphQLTest(
      """
      mutation CreateFriendResidenceDuration($input: CreateFriendResidenceDurationInput!) {
        download: createFriendResidenceDuration(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetFriendResidenceDuration() async throws {
    let friendResidenceDuration = try await Current.db.createFriendResidenceDuration(.random)

    GraphQLTest(
      """
      query GetFriendResidenceDuration {
        friendResidenceDuration: getFriendResidenceDuration(id: "\(friendResidenceDuration.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friendResidenceDuration.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateFriendResidenceDuration() async throws {
    let friendResidenceDuration = try await Current.db.createFriendResidenceDuration(.random)

    // do some updates here ---vvv
    friendResidenceDuration.start = 1699

    GraphQLTest(
      """
      mutation UpdateFriendResidenceDuration($input: UpdateFriendResidenceDurationInput!) {
        friendResidenceDuration: updateFriendResidenceDuration(input: $input) {
          start
        }
      }
      """,
      expectedData: .containsKVPs(["start": 1699]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friendResidenceDuration.gqlMap()])
  }

  func testDeleteFriendResidenceDuration() async throws {
    let friendResidenceDuration = try await Current.db.createFriendResidenceDuration(.random)

    GraphQLTest(
      """
      mutation DeleteFriendResidenceDuration {
        friendResidenceDuration: deleteFriendResidenceDuration(id: "\(friendResidenceDuration.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friendResidenceDuration.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friendResidenceDuration.gqlMap()])

    let retrieved = try? await Current.db.getFriendResidenceDuration(friendResidenceDuration.id)
    XCTAssertNil(retrieved)
  }
}
