import XCTVapor
import XCTVaporUtils

@testable import App

final class EditionImpressionResolverTests: AppTestCase {

  func testCreateEditionImpression() async throws {
    let entities = await Entities.create()
    try await Current.db.delete(entities.editionImpression.id)
    let editionImpression = EditionImpression.valid
    editionImpression.editionId = entities.edition.id
    let map = editionImpression.gqlMap()

    GraphQLTest(
      """
      mutation CreateEditionImpression($input: CreateEditionImpressionInput!) {
        editionImpression: createEditionImpression(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetEditionImpression() async throws {
    let entities = await Entities.create()
    let editionImpression = entities.editionImpression

    GraphQLTest(
      """
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
      expectedData: .containsKVPs([
        "id": editionImpression.id.lowercased,
        "logPath": DownloadableFile(edition: entities.edition, format: .ebook(.epub))
          .logPath
          .replacingOccurrences(of: "/", with: "\\/"),
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateEditionImpression() async throws {
    let editionImpression = await Entities.create().editionImpression

    // do some updates here ---vvv
    editionImpression.adocLength = 33333

    GraphQLTest(
      """
      mutation UpdateEditionImpression($input: UpdateEditionImpressionInput!) {
        editionImpression: updateEditionImpression(input: $input) {
          adocLength
        }
      }
      """,
      expectedData: .containsKVPs(["adocLength": 33333]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionImpression.gqlMap()])
  }

  func testDeleteEditionImpression() async throws {
    let editionImpression = await Entities.create().editionImpression

    GraphQLTest(
      """
      mutation DeleteEditionImpression {
        editionImpression: deleteEditionImpression(id: "\(editionImpression.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionImpression.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionImpression.gqlMap()])

    let retrieved = try? await Current.db.find(editionImpression.id)
    XCTAssertNil(retrieved)
  }
}
