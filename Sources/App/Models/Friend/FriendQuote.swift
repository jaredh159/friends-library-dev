import Fluent
import Vapor

final class FriendQuote: Model, Content {
  static let schema = M12.tableName

  @ID(key: .id)
  var id: UUID?

  @Field(key: M12.source)
  var source: String

  @Field(key: M12.text)
  var text: String

  @Field(key: M12.order)
  var order: Int

  @OptionalField(key: M12.context)
  var context: String?

  @Parent(key: M12.friendId)
  var friend: Friend

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?

  init() {}
}

extension FriendQuote {
  enum M12 {
    static let tableName = "friend_quotes"
    static let source = FieldKey("source")
    static let text = FieldKey("text")
    static let order = FieldKey("order")
    static let context = FieldKey("context")
    static let friendId = FieldKey("friend_id")
  }
}
