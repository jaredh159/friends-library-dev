// auto-generated, do not edit
import GraphQL

@testable import App

extension RelatedDocument {
  static var mock: RelatedDocument {
    RelatedDocument(
      description: "@mock description",
      documentId: .init(),
      parentDocumentId: .init()
    )
  }

  static var empty: RelatedDocument {
    RelatedDocument(description: "", documentId: .init(), parentDocumentId: .init())
  }

  static var random: RelatedDocument {
    RelatedDocument(description: "@random".random, documentId: .init(), parentDocumentId: .init())
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "description": .string(description),
      "documentId": .string(documentId.rawValue.uuidString),
      "parentDocumentId": .string(parentDocumentId.rawValue.uuidString),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
