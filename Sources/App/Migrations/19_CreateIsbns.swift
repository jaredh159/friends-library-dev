import Fluent

struct CreateIsbns: Migration {
  private typealias M19 = Isbn.M19

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M19.tableName)
      .id()
      .field(M19.code, .string, .required)
      .field(
        M19.editionId,
        .uuid,
        .references(Edition.M17.tableName, .id, onDelete: .cascade)
      )
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .unique(on: M19.code)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M19.tableName).delete()
  }
}
