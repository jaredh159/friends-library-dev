import XCTVapor
import XCTVaporUtils

@testable import App

final class IsbnResolverTests: AppTestCase {

  func testCreateIsbn() async throws {
    let isbn = Isbn.random
    isbn.editionId = nil
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
    isbn.editionId = nil
    try await Current.db.create(isbn)

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
    isbn.editionId = nil
    try await Current.db.create(isbn)

    // do some updates here ---vvv
    isbn.code = .init(rawValue: "new value".random)

    GraphQLTest(
      """
      mutation UpdateIsbn($input: UpdateIsbnInput!) {
        isbn: updateIsbn(input: $input) {
          code
        }
      }
      """,
      expectedData: .containsKVPs(["code": isbn.code.rawValue]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": isbn.gqlMap()])
  }

  func testDeleteIsbn() async throws {
    let isbn = Isbn.random
    isbn.editionId = nil
    try await Current.db.create(isbn)

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

    let retrieved = try? await Current.db.find(Isbn.self, byId: isbn.id)
    XCTAssertNil(retrieved)
  }
}
