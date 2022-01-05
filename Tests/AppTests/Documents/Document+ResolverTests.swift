import XCTVapor
import XCTVaporUtils

@testable import App

final class DocumentResolverTests: AppTestCase {

  func testCreateDocument() async throws {
    let entities = await Entities.create()
    let document: Document = .random
    document.altLanguageId = nil
    document.friendId = entities.friend.id
    let map = document.gqlMap()

    GraphQLTest(
      """
      mutation CreateDocument($input: CreateDocumentInput!) {
        download: createDocument(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetDocument() async throws {
    let document = await Entities.create().document

    GraphQLTest(
      """
      query GetDocument {
        document: getDocument(id: "\(document.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": document.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateDocument() async throws {
    let document = await Entities.create().document

    // do some updates here ---vvv
    document.title = "new value".random

    GraphQLTest(
      """
      mutation UpdateDocument($input: UpdateDocumentInput!) {
        document: updateDocument(input: $input) {
          title
        }
      }
      """,
      expectedData: .containsKVPs(["title": document.title]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": document.gqlMap()])
  }

  func testDeleteDocument() async throws {
    let document = await Entities.create().document

    GraphQLTest(
      """
      mutation DeleteDocument {
        document: deleteDocument(id: "\(document.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": document.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": document.gqlMap()])

    let retrieved = try? await Current.db.getDocument(document.id)
    XCTAssertNil(retrieved)
  }
}
