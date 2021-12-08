import Fluent
import Vapor

struct CreateDocuments: Migration {
  private typealias M13 = Document.M13

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M13.tableName)
      .id()
      .field(
        M13.friendId,
        .uuid,
        .references(Friend.M10.tableName, .id, onDelete: .setNull),
        .required
      )
      .field(
        M13.altLanguageId,
        .uuid,
        .references(M13.tableName, .id, onDelete: .setNull)
      )
      .field(M13.title, .string, .required)
      .field(M13.slug, .string, .required)
      .field(M13.filename, .string, .required)
      .field(M13.published, .int)
      .field(M13.originalTitle, .string)
      .field(M13.incomplete, .bool, .required)
      .field(M13.description, .string, .required)
      .field(M13.partialDescription, .string, .required)
      .field(M13.featuredDescription, .string)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .field(.deletedAt, .datetime)
      .unique(on: M13.filename)
      .unique(on: M13.title)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M13.tableName).delete()
  }
}
