import Fluent

struct CreateRelatedDocuments: Migration {
  private typealias M22 = RelatedDocument.M22

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M22.tableName)
      .id()
      .field(
        M22.parentDocumentId,
        .uuid,
        .references(Document.M13.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(
        M22.documentId,
        .uuid,
        .references(Document.M13.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(M22.description, .string, .required)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M22.tableName).delete()
  }
}
