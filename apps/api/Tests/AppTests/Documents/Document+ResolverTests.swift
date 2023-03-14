import XCTest

@testable import App

final class DocumentResolverTests: AppTestCase {

  func testCreateDocument() async throws {
    let entities = await Entities.create()
    let document: Document = .valid
    document.altLanguageId = nil
    document.friendId = entities.friend.id
    let map = document.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateDocument($input: CreateDocumentInput!) {
        document: createDocument(input: $input) {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetDocument() async throws {
    let document = await Entities.create().document

    assertResponse(
      to: /* gql */ """
      query GetDocument {
        document: getDocument(id: "\(document.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs(["id": document.id.lowercased])
    )
  }

  func testGetRelatedDocument() async throws {
    let entities1 = await Entities.create()
    let entities2 = await Entities.create()

    let relatedDoc: RelatedDocument = .random
    relatedDoc.parentDocumentId = entities1.document.id
    relatedDoc.documentId = entities2.document.id
    try await Current.db.create(relatedDoc)

    assertResponse(
      to: /* gql */ """
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
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs([
        "id": entities1.document.id.lowercased,
        "relatedDocumentId": relatedDoc.id.lowercased,
        "relatedDocumentParentDocumentId": entities1.document.id.lowercased,
        "relatedDocumentDocumentId": entities2.document.id.lowercased,
      ])
    )
  }

  func testUpdateDocument() async throws {
    let document = await Entities.create().document

    // do some updates here ---vvv
    document.title = "New value".random

    assertResponse(
      to: /* gql */ """
      mutation UpdateDocument($input: UpdateDocumentInput!) {
        document: updateDocument(input: $input) {
          title
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": document.gqlMap()],
      .containsKeyValuePairs(["title": document.title])
    )
  }

  func testDeleteDocument() async throws {
    let document = await Entities.create().document

    assertResponse(
      to: /* gql */ """
      mutation DeleteDocument {
        document: deleteDocument(id: "\(document.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": document.gqlMap()],
      .containsKeyValuePairs(["id": document.id.lowercased])
    )

    let retrieved = try? await Current.db.find(document.id)
    XCTAssertNil(retrieved)
  }
}
