import Fluent

struct CreateRelatedDocuments: Migration {
  private typealias M23 = RelatedDocument.M23

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M23.tableName)
      .id()
      .field(
        M23.parentDocumentId,
        .uuid,
        .references(Document.M14.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(
        M23.documentId,
        .uuid,
        .references(Document.M14.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(M23.description, .string, .required)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M23.tableName).delete()
  }
}
