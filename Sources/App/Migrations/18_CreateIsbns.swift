import Fluent

struct CreateIsbns: Migration {
  private typealias M18 = Isbn.M18

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M18.tableName)
      .id()
      .field(M18.code, .string, .required)
      .field(
        M18.editionId,
        .uuid,
        .references(Edition.M16.tableName, .id, onDelete: .cascade)
      )
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .unique(on: M18.code)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M18.tableName).delete()
  }
}
