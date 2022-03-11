import XCTVapor
import XCTVaporUtils

@testable import App

final class EditionChapterResolverTests: AppTestCase {

  func testCreateEditionChapter() async throws {
    _ = try await Current.db.query(EditionChapter.self).delete()
    let edition = await Entities.create().edition
    let editionChapter = EditionChapter.valid
    editionChapter.editionId = edition.id
    let map = editionChapter.gqlMap()

    GraphQLTest(
      """
      mutation CreateEditionChapter($input: CreateEditionChapterInput!) {
        editionChapter: createEditionChapter(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetEditionChapter() async throws {
    let editionChapter = await Entities.create().editionChapter

    GraphQLTest(
      """
      query GetEditionChapter {
        editionChapter: getEditionChapter(id: "\(editionChapter.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionChapter.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateEditionChapter() async throws {
    let editionChapter = await Entities.create().editionChapter

    // do some updates here ---vvv
    editionChapter.shortHeading = "New value"

    GraphQLTest(
      """
      mutation UpdateEditionChapter($input: UpdateEditionChapterInput!) {
        editionChapter: updateEditionChapter(input: $input) {
          shortHeading
        }
      }
      """,
      expectedData: .containsKVPs(["shortHeading": "New value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionChapter.gqlMap()])
  }

  func testDeleteEditionChapter() async throws {
    let editionChapter = await Entities.create().editionChapter

    GraphQLTest(
      """
      mutation DeleteEditionChapter {
        editionChapter: deleteEditionChapter(id: "\(editionChapter.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionChapter.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionChapter.gqlMap()])

    let retrieved = try? await Current.db.find(editionChapter.id)
    XCTAssertNil(retrieved)
  }
}
