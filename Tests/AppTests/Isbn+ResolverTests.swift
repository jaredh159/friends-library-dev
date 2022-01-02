import XCTVapor
import XCTVaporUtils

@testable import App

final class IsbnResolverTests: AppTestCase {

  func testCreateIsbn() async throws {
    let isbn = Isbn.random
    let map = isbn.gqlMap()

    GraphQLTest(
      """
      mutation CreateIsbn($input: CreateIsbnInput!) {
        download: createIsbn(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetIsbn() async throws {
    let isbn = Isbn.random
    try await Current.db.createIsbn(isbn)

    GraphQLTest(
      """
      query GetIsbn {
        isbn: getIsbn(id: "\(isbn.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": isbn.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateIsbn() async throws {
    let isbn = Isbn.random
    try await Current.db.createIsbn(isbn)

    // do some updates here ---vvv
    isbn.code = "new value"

    GraphQLTest(
      """
      mutation UpdateIsbn($input: UpdateIsbnInput!) {
        isbn: updateIsbn(input: $input) {
          code
        }
      }
      """,
      expectedData: .containsKVPs(["code": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": isbn.gqlMap()])
  }

  func testDeleteIsbn() async throws {
    let isbn = Isbn.random
    try await Current.db.createIsbn(isbn)

    GraphQLTest(
      """
      mutation DeleteIsbn {
        isbn: deleteIsbn(id: "\(isbn.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": isbn.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": isbn.gqlMap()])

    let retrieved = try? await Current.db.getIsbn(isbn.id)
    XCTAssertNil(retrieved)
  }
}
