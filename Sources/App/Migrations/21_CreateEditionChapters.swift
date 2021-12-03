import Fluent

struct CreateEditionChapters: Migration {
  private typealias M21 = EditionChapter.M21

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M21.tableName)
      .id()
      .field(
        M21.editionId,
        .uuid,
        .references(Edition.M16.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(M21.order, .int, .required)
      .field(M21.customId, .string)
      .field(M21.shortHeading, .string, .required)
      .field(M21.isIntermediateTitle, .string, .required)
      .field(M21.sequenceNumber, .int)
      .field(M21.nonSequenceTitle, .string)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .unique(on: M21.editionId, M21.order)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M21.tableName).delete()
  }
}
