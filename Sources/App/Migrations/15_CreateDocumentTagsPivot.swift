import Fluent

struct CreateDocumentTagsPivot: Migration {
  func prepare(on database: Database) -> Future<Void> {
    return database.schema(M15.tableName)
      .id()
      .field(
        M15.documentTagId,
        .uuid,
        .required,
        .references(DocumentTagModel.M14.tableName, .id, onDelete: .cascade)
      )
      .field(
        M15.documentId,
        .uuid,
        .required,
        .references(Document.M13.tableName, .id, onDelete: .cascade)
      )
      .field(.createdAt, .datetime, .required)
      .unique(on: M15.documentTagId, M15.documentId)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M15.tableName).delete()
  }
}

extension CreateDocumentTagsPivot {
  enum M15 {
    static let tableName = "documents_tags_pivot"
    static let documentTagId = FieldKey("document_tag_id")
    static let documentId = FieldKey("document_id")
  }
}
