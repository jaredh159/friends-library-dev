import XCTest

@testable import App

final class EditionResolverTests: AppTestCase {

  func testCreateEdition() async throws {
    let isbn = Isbn(code: .init(rawValue: UUID().uuidString), editionId: nil)
    try await Current.db.deleteAll(Edition.self)
    try await Current.db.create(isbn)
    let entities = await Entities.create()
    _ = try await Current.db.delete(entities.edition.id, force: true)
    let edition: Edition = .valid
    edition.documentId = entities.document.id
    let map = edition.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateEdition($input: CreateEditionInput!) {
        edition: createEdition(input: $input) {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetEdition() async throws {
    let edition = await Entities.create().edition

    assertResponse(
      to: /* gql */ """
      query GetEdition {
        edition: getEdition(id: "\(edition.id.uuidString)") {
          id
          images {
            square {
              w45 {
                width
              }
            }
          }
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs(["id": edition.id.lowercased, "width": 45])
    )
  }

  func testUpdateEdition() async throws {
    let edition = await Entities.create { $0.edition.type = .updated }.edition

    // do some updates here ---vvv
    edition.editor = "Bob Smith"

    assertResponse(
      to: /* gql */ """
      mutation UpdateEdition($input: UpdateEditionInput!) {
        edition: updateEdition(input: $input) {
          editor
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": edition.gqlMap()],
      .containsKeyValuePairs(["editor": "Bob Smith"])
    )
  }

  func testDeleteEdition() async throws {
    let edition = await Entities.create().edition

    assertResponse(
      to: /* gql */ """
      mutation DeleteEdition {
        edition: deleteEdition(id: "\(edition.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": edition.gqlMap()],
      .containsKeyValuePairs(["id": edition.id.lowercased])
    )

    let retrieved = try? await Current.db.find(edition.id)
    XCTAssertNil(retrieved)
  }
}
