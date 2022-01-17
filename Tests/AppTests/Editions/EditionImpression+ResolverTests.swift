import XCTVapor
import XCTVaporUtils

@testable import App

final class EditionImpressionResolverTests: AppTestCase {

  func testCreateEditionImpression() async throws {
    let entities = await Entities.create()
    try await Current.db.delete(EditionImpression.self, byId: entities.editionImpression.id)
    let editionImpression = EditionImpression.random
    editionImpression.editionId = entities.edition.id
    let map = editionImpression.gqlMap()

    GraphQLTest(
      """
      mutation CreateEditionImpression($input: CreateEditionImpressionInput!) {
        download: createEditionImpression(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetEditionImpression() async throws {
    let editionImpression = await Entities.create().editionImpression

    GraphQLTest(
      """
      query GetEditionImpression {
        editionImpression: getEditionImpression(id: "\(editionImpression.id.uuidString)") {
          id
          paperbackVolumes
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionImpression.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateEditionImpression() async throws {
    let editionImpression = await Entities.create().editionImpression

    // do some updates here ---vvv
    editionImpression.adocLength = 333

    GraphQLTest(
      """
      mutation UpdateEditionImpression($input: UpdateEditionImpressionInput!) {
        editionImpression: updateEditionImpression(input: $input) {
          adocLength
        }
      }
      """,
      expectedData: .containsKVPs(["adocLength": 333]),
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
      expectedData: .containsKVPs(["id": editionImpression.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionImpression.gqlMap()])

    let retrieved = try? await Current.db.find(EditionImpression.self, byId: editionImpression.id)
    XCTAssertNil(retrieved)
  }
}
