import Fluent
import Vapor

struct CreateFriendResidences: Migration {
  private typealias M11 = FriendResidence.M11

  func prepare(on database: Database) -> Future<Void> {
    database.schema(M11.tableName)
      .id()
      .field(
        M11.friendId,
        .uuid,
        .required,
        .references(Friend.M10.tableName, .id, onDelete: .cascade)
      )
      .field(M11.city, .string, .required)
      .field(M11.region, .string, .required)
      .field(M11.duration, .dictionary)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M11.tableName).delete()
  }
}
