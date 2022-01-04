import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendResolverTests: AppTestCase {

  func testCreateFriend() async throws {
    let friend = Friend.random
    let map = friend.gqlMap()

    GraphQLTest(
      """
      mutation CreateFriend($input: CreateFriendInput!) {
        download: createFriend(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetFriend() async throws {
    let friend = try await Current.db.createFriend(.random)

    GraphQLTest(
      """
      query GetFriend {
        friend: getFriend(id: "\(friend.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friend.id.uuidString]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateFriend() async throws {
    let friend = try await Current.db.createFriend(.random)

    // do some updates here ---vvv
    friend.name = "Bob"

    GraphQLTest(
      """
      mutation UpdateFriend($input: UpdateFriendInput!) {
        friend: updateFriend(input: $input) {
          name
        }
      }
      """,
      expectedData: .containsKVPs(["name": "Bob"]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friend.gqlMap()])
  }

  func testDeleteFriend() async throws {
    let friend = try await Current.db.createFriend(.random)

    GraphQLTest(
      """
      mutation DeleteFriend {
        friend: deleteFriend(id: "\(friend.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friend.id.uuidString]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friend.gqlMap()])

    let retrieved = try? await Current.db.getFriend(friend.id)
    XCTAssertNil(retrieved)
  }
}
