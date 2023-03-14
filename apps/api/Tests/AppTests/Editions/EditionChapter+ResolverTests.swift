import XCTest

@testable import App

final class EditionChapterResolverTests: AppTestCase {

  func testCreateEditionChapter() async throws {
    _ = try await Current.db.query(EditionChapter.self).delete()
    let edition = await Entities.create().edition
    let editionChapter = EditionChapter.valid
    editionChapter.editionId = edition.id
    let map = editionChapter.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateEditionChapter($input: CreateEditionChapterInput!) {
        editionChapter: createEditionChapter(input: $input) {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetEditionChapter() async throws {
    let editionChapter = await Entities.create().editionChapter

    assertResponse(
      to: /* gql */ """
      query GetEditionChapter {
        editionChapter: getEditionChapter(id: "\(editionChapter.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs(["id": editionChapter.id.lowercased])
    )
  }

  func testUpdateEditionChapter() async throws {
    let editionChapter = await Entities.create().editionChapter

    // do some updates here ---vvv
    editionChapter.shortHeading = "New value"

    assertResponse(
      to: /* gql */ """
      mutation UpdateEditionChapter($input: UpdateEditionChapterInput!) {
        editionChapter: updateEditionChapter(input: $input) {
          shortHeading
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": editionChapter.gqlMap()],
      .containsKeyValuePairs(["shortHeading": "New value"])
    )
  }

  func testDeleteEditionChapter() async throws {
    let editionChapter = await Entities.create().editionChapter

    assertResponse(
      to: /* gql */ """
      mutation DeleteEditionChapter {
        editionChapter: deleteEditionChapter(id: "\(editionChapter.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": editionChapter.gqlMap()],
      .containsKeyValuePairs(["id": editionChapter.id.lowercased])
    )

    let retrieved = try? await Current.db.find(editionChapter.id)
    XCTAssertNil(retrieved)
  }
}
