import Fluent
import Foundation
import Vapor

final class RelatedDocument: Model, Content {
  static let schema = M22.tableName

  @ID(key: .id)
  var id: UUID?

  // @Parent(key: M22.parentDocumentId)
  // var parentDocument: Document

  // @Parent(key: M22.documentId)
  // var document: Document

  @Field(key: M22.description)
  var description: String

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?
}

extension RelatedDocument {
  enum M22 {
    static let tableName = "related_documents"
    static let parentDocumentId = FieldKey("parent_document_id")
    static let documentId = FieldKey("document_id")
    static let description = FieldKey("description")
  }
}
