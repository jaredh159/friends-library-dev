import XCTVapor
import XCTVaporUtils

@testable import App

final class EditionResolverTests: AppTestCase {

  func testCreateEdition() async throws {
    let entities = await Entities.create()
    _ = try await Current.db.deleteEdition(entities.edition.id)
    let edition: Edition = .random
    edition.documentId = entities.document.id
    let map = edition.gqlMap()

    GraphQLTest(
      """
      mutation CreateEdition($input: CreateEditionInput!) {
        download: createEdition(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetEdition() async throws {
    let edition = await Entities.create().edition

    GraphQLTest(
      """
      query GetEdition {
        edition: getEdition(id: "\(edition.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": edition.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateEdition() async throws {
    let edition = await Entities.create().edition

    // do some updates here ---vvv
    edition.editor = "new value"

    GraphQLTest(
      """
      mutation UpdateEdition($input: UpdateEditionInput!) {
        edition: updateEdition(input: $input) {
          editor
        }
      }
      """,
      expectedData: .containsKVPs(["editor": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": edition.gqlMap()])
  }

  func testDeleteEdition() async throws {
    let edition = await Entities.create().edition

    GraphQLTest(
      """
      mutation DeleteEdition {
        edition: deleteEdition(id: "\(edition.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": edition.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": edition.gqlMap()])

    let retrieved = try? await Current.db.getEdition(edition.id)
    XCTAssertNil(retrieved)
  }
}
