import Fluent

struct CreateAudioParts: Migration {
  private typealias M20 = AudioPart.M20

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M20.tableName)
      .id()
      .field(
        M20.audioId,
        .uuid,
        .references(Audio.M19.tableName, .id, onDelete: .cascade),
        .required
      )
      .field(M20.title, .string, .required)
      .field(M20.duration, .double, .required)
      .field(M20.chapters, .array(of: .int), .required)
      .field(M20.order, .int, .required)
      .field(M20.mp3SizeHq, .int, .required)
      .field(M20.mp3SizeLq, .int, .required)
      .field(M20.externalIdHq, .int64)
      .field(M20.externalIdLq, .int64)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .unique(on: M20.audioId, M20.order)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M20.tableName).delete()
  }
}
