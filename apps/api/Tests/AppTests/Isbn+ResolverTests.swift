import XCTest

@testable import App

final class IsbnResolverTests: AppTestCase {

  func testCreateIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
    isbn.editionId = nil
    let map = isbn.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateIsbn($input: CreateIsbnInput!) {
        isbn: createIsbn(input: $input) {
          id
        }
      }
      """,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
    isbn.editionId = nil
    try await Current.db.create(isbn)

    assertResponse(
      to: /* gql */ """
      query GetIsbn {
        isbn: getIsbn(id: "\(isbn.id.uuidString)") {
          id
        }
      }
      """,
      .containsKeyValuePairs(["id": isbn.id.lowercased])
    )
  }

  func testUpdateIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
    isbn.editionId = nil
    try await Current.db.create(isbn)

    // do some updates here ---vvv
    isbn.code = .init(rawValue: "978-1-64476-123-1")

    assertResponse(
      to: /* gql */ """
      mutation UpdateIsbn($input: UpdateIsbnInput!) {
        isbn: updateIsbn(input: $input) {
          code
        }
      }
      """,
      withVariables: ["input": isbn.gqlMap()],
      .containsKeyValuePairs(["code": "978-1-64476-123-1"])
    )
  }

  func testDeleteIsbn() async throws {
    _ = try await Current.db.query(Isbn.self).delete()
    let isbn = Isbn.valid
    isbn.editionId = nil
    try await Current.db.create(isbn)

    assertResponse(
      to: /* gql */ """
      mutation DeleteIsbn {
        isbn: deleteIsbn(id: "\(isbn.id.uuidString)") {
          id
        }
      }
      """,
      withVariables: ["input": isbn.gqlMap()],
      .containsKeyValuePairs(["id": isbn.id.lowercased])
    )

    let retrieved = try? await Current.db.find(isbn.id)
    XCTAssertNil(retrieved)
  }
}
