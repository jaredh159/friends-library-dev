import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendResidenceResolverTests: AppTestCase {

  func testCreateFriendResidence() async throws {
    let friendResidence = FriendResidence.random
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
    let friendResidence = try await Current.db.createFriendResidence(.random)

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
    let friendResidence = try await Current.db.createFriendResidence(.random)

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
    let friendResidence = try await Current.db.createFriendResidence(.random)

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
