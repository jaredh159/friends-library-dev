import Fluent

struct CreateDocumentTagsPivot: Migration {
  func prepare(on database: Database) -> Future<Void> {
    return database.schema(M16.tableName)
      .id()
      .field(
        M16.documentTagId,
        .uuid,
        .required,
        .references(DocumentTagModel.M15.tableName, .id, onDelete: .cascade)
      )
      .field(
        M16.documentId,
        .uuid,
        .required,
        .references(Document.M14.tableName, .id, onDelete: .cascade)
      )
      .field(.createdAt, .datetime, .required)
      .unique(on: M16.documentTagId, M16.documentId)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M16.tableName).delete()
  }
}

extension CreateDocumentTagsPivot {
  enum M16 {
    static let tableName = "documents_tags_pivot"
    static let documentTagId = FieldKey("document_tag_id")
    static let documentId = FieldKey("document_id")
  }
}
