import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendResidenceResolverTests: AppTestCase {

  func testCreateFriendResidence() async throws {
    let friend = await Entities.create().friend
    let friendResidence = FriendResidence.random
    friendResidence.friendId = friend.id
    let map = friendResidence.gqlMap()

    GraphQLTest(
      """
      mutation CreateFriendResidence($input: CreateFriendResidenceInput!) {
        download: createFriendResidence(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetFriendResidence() async throws {
    let friendResidence = await Entities.create().friendResidence

    GraphQLTest(
      """
      query GetFriendResidence {
        friendResidence: getFriendResidence(id: "\(friendResidence.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friendResidence.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateFriendResidence() async throws {
    let friendResidence = await Entities.create().friendResidence

    // do some updates here ---vvv
    friendResidence.city = "new value"

    GraphQLTest(
      """
      mutation UpdateFriendResidence($input: UpdateFriendResidenceInput!) {
        friendResidence: updateFriendResidence(input: $input) {
          city
        }
      }
      """,
      expectedData: .containsKVPs(["city": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friendResidence.gqlMap()])
  }

  func testDeleteFriendResidence() async throws {
    let friendResidence = await Entities.create().friendResidence

    GraphQLTest(
      """
      mutation DeleteFriendResidence {
        friendResidence: deleteFriendResidence(id: "\(friendResidence.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friendResidence.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friendResidence.gqlMap()])

    let retrieved = try? await Current.db.getFriendResidence(friendResidence.id)
    XCTAssertNil(retrieved)
  }
}
