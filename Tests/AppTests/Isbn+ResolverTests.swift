import XCTVapor
import XCTVaporUtils

@testable import App

final class IsbnResolverTests: AppTestCase {

  func testCreateIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
    isbn.editionId = nil
    let map = isbn.gqlMap()

    GraphQLTest(
      """
      mutation CreateIsbn($input: CreateIsbnInput!) {
        isbn: createIsbn(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
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
      expectedData: .containsKVPs(["id": isbn.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
    isbn.editionId = nil
    try await Current.db.create(isbn)

    // do some updates here ---vvv
    isbn.code = .init(rawValue: "978-1-64476-123-1")

    GraphQLTest(
      """
      mutation UpdateIsbn($input: UpdateIsbnInput!) {
        isbn: updateIsbn(input: $input) {
          code
        }
      }
      """,
      expectedData: .containsKVPs(["code": "978-1-64476-123-1"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": isbn.gqlMap()])
  }

  func testDeleteIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
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
      expectedData: .containsKVPs(["id": isbn.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": isbn.gqlMap()])

    let retrieved = try? await Current.db.find(isbn.id)
    XCTAssertNil(retrieved)
  }
}
