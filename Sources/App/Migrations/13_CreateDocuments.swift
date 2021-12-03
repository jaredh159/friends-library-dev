import Fluent
import Vapor

struct CreateDocuments: Migration {
  private typealias M13 = Document.M13

  func prepare(on database: Database) -> Future<Void> {
    database.enum(Order.M2.LangEnum.name).read().flatMap { langs in
      database.schema(M13.tableName)
        .id()
        .field(M13.lang, langs, .required)
        .field(
          M13.altLanguageId,
          .uuid,
          .references(M13.tableName, FieldKey.id, onDelete: .setNull)
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
        .field(.deletedAt, .datetime, .required)
        .create()
    }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M13.tableName).delete()
  }
}
