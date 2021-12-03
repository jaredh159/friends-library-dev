import Fluent

struct CreateAudios: Migration {
  private typealias M19 = Audio.M19

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M19.tableName)
      .id()
      .field(
        M19.editionId,
        .uuid,
        .references(Edition.M16.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(M19.reader, .string, .required)
      .field(M19.isIncomplete, .bool, .required)
      .field(M19.mp3ZipSizeHq, .int, .required)
      .field(M19.mp3ZipSizeLq, .int, .required)
      .field(M19.m4bSizeHq, .int, .required)
      .field(M19.m4bSizeLq, .int, .required)
      .field(M19.externalPlaylistIdHq, .int64)
      .field(M19.externalPlaylistIdLq, .int64)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .unique(on: M19.editionId)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M19.tableName).delete()
  }
}
