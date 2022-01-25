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
      expectedData: .containsKVPs(["id": document.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testGetRelatedDocument() async throws {
    let entities1 = await Entities.create()
    let entities2 = await Entities.create()

    let relatedDoc: RelatedDocument = .random
    relatedDoc.parentDocumentId = entities1.document.id
    relatedDoc.documentId = entities2.document.id
    try await Current.db.create(relatedDoc)

    GraphQLTest(
      """
      query GetDocument {
        document: getDocument(id: "\(entities1.document.id.uuidString)") {
          id
          relatedDocuments {
            relatedDocumentId: id
            parentDocument {
              relatedDocumentParentDocumentId: id
            }
            document {
              relatedDocumentDocumentId: id
            }
          }
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": entities1.document.id.lowercased,
        "relatedDocumentId": relatedDoc.id.lowercased,
        "relatedDocumentParentDocumentId": entities1.document.id.lowercased,
        "relatedDocumentDocumentId": entities2.document.id.lowercased,
      ]),
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
      expectedData: .containsKVPs(["id": document.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": document.gqlMap()])

    let retrieved = try? await Current.db.find(document.id)
    XCTAssertNil(retrieved)
  }
}
