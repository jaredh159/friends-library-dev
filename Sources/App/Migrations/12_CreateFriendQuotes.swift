import Fluent
import Vapor

struct CreateFriendQuotes: Migration {
  private typealias M12 = FriendQuote.M12

  func prepare(on database: Database) -> Future<Void> {
    return database.schema(M12.tableName)
      .id()
      .field(M12.source, .string, .required)
      .field(M12.text, .string, .required)
      .field(M12.order, .int, .required)
      .field(M12.context, .string)
      .field(
        M12.friendId,
        .uuid,
        .required,
        .references(Friend.M10.tableName, FieldKey.id, onDelete: .cascade)
      )
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M12.tableName).delete()
  }
}
