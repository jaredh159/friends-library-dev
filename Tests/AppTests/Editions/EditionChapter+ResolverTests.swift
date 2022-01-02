import XCTVapor
import XCTVaporUtils

@testable import App

final class EditionChapterResolverTests: AppTestCase {

  func testCreateEditionChapter() async throws {
    let editionChapter = EditionChapter.random
    let map = editionChapter.gqlMap()

    GraphQLTest(
      """
      mutation CreateEditionChapter($input: CreateEditionChapterInput!) {
        download: createEditionChapter(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetEditionChapter() async throws {
    let editionChapter = EditionChapter.random
    try await Current.db.createEditionChapter(editionChapter)

    GraphQLTest(
      """
      query GetEditionChapter {
        editionChapter: getEditionChapter(id: "\(editionChapter.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionChapter.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateEditionChapter() async throws {
    let editionChapter = EditionChapter.random
    try await Current.db.createEditionChapter(editionChapter)

    // do some updates here ---vvv
    editionChapter.shortHeading = "new value"

    GraphQLTest(
      """
      mutation UpdateEditionChapter($input: UpdateEditionChapterInput!) {
        editionChapter: updateEditionChapter(input: $input) {
          shortHeading
        }
      }
      """,
      expectedData: .containsKVPs(["shortHeading": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionChapter.gqlMap()])
  }

  func testDeleteEditionChapter() async throws {
    let editionChapter = EditionChapter.random
    try await Current.db.createEditionChapter(editionChapter)

    GraphQLTest(
      """
      mutation DeleteEditionChapter {
        editionChapter: deleteEditionChapter(id: "\(editionChapter.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": editionChapter.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": editionChapter.gqlMap()])

    let retrieved = try? await Current.db.getEditionChapter(editionChapter.id)
    XCTAssertNil(retrieved)
  }
}
