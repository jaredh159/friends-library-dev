import Fluent
import Vapor

struct CreateFriendQuotes: Migration {
  private typealias M12 = FriendQuote.M12

  func prepare(on database: Database) -> Future<Void> {
    return database.schema(M12.tableName)
      .id()
      .field(
        M12.friendId,
        .uuid,
        .required,
        .references(Friend.M10.tableName, .id, onDelete: .cascade)
      )
      .field(M12.source, .string, .required)
      .field(M12.text, .string, .required)
      .field(M12.order, .int, .required)
      .field(M12.context, .string)
      .field(.createdAt, .datetime, .required)
      .field(.updatedAt, .datetime, .required)
      .unique(on: M12.friendId, M12.order)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M12.tableName).delete()
  }
}
