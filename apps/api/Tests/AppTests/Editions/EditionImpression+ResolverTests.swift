import XCTest

@testable import App

final class EditionImpressionResolverTests: AppTestCase {

  func testCreateEditionImpression() async throws {
    let entities = await Entities.create()
    try await Current.db.delete(entities.editionImpression.id)
    let editionImpression = EditionImpression.valid
    editionImpression.editionId = entities.edition.id
    let map = editionImpression.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateEditionImpression($input: CreateEditionImpressionInput!) {
        editionImpression: createEditionImpression(input: $input) {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetEditionImpression() async throws {
    let entities = await Entities.create()
    let editionImpression = entities.editionImpression

    assertResponse(
      to: /* gql */ """
      query GetEditionImpression {
        editionImpression: getEditionImpression(id: "\(editionImpression.id.uuidString)") {
          id
          paperbackVolumes
          files {
            ebook {
              epub {
                logPath
              }
            }
          }
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs([
        "id": editionImpression.id.lowercased,
        "logPath": DownloadableFile(edition: entities.edition, format: .ebook(.epub))
          .logPath
          .replacingOccurrences(of: "/", with: "\\/"),
      ])
    )
  }

  func testUpdateEditionImpression() async throws {
    let editionImpression = await Entities.create().editionImpression

    // do some updates here ---vvv
    editionImpression.adocLength = 33333

    assertResponse(
      to: /* gql */ """
      mutation UpdateEditionImpression($input: UpdateEditionImpressionInput!) {
        editionImpression: updateEditionImpression(input: $input) {
          adocLength
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": editionImpression.gqlMap()],
      .containsKeyValuePairs(["adocLength": 33333])
    )
  }

  func testDeleteEditionImpression() async throws {
    let editionImpression = await Entities.create().editionImpression

    assertResponse(
      to: /* gql */ """
      mutation DeleteEditionImpression {
        editionImpression: deleteEditionImpression(id: "\(editionImpression.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": editionImpression.gqlMap()],
      .containsKeyValuePairs(["id": editionImpression.id.lowercased])
    )

    let retrieved = try? await Current.db.find(editionImpression.id)
    XCTAssertNil(retrieved)
  }
}
