import XCTVapor
import XCTVaporUtils

@testable import App

final class EditionImpressionResolverTests: AppTestCase {

  func testCreateEditionImpression() async throws {
    let editionImpression = EditionImpression.random
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
    let editionImpression = try await Current.db.createEditionImpression(.random)

    GraphQLTest(
      """
      query GetEditionImpression {
        editionImpression: getEditionImpression(id: "\(editionImpression.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionImpression.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateEditionImpression() async throws {
    let editionImpression = try await Current.db.createEditionImpression(.random)

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
    let editionImpression = try await Current.db.createEditionImpression(.random)

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

    let retrieved = try? await Current.db.getEditionImpression(editionImpression.id)
    XCTAssertNil(retrieved)
  }
}
