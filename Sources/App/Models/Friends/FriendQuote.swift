import Fluent
import Foundation
import Tagged

final class FriendQuote {
  var id: Id
  var friendId: Friend.Id
  var source: String
  var order: Int
  var context: String?
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var friend = Parent<Friend>.notLoaded

  init(
    id: Id = .init(),
    friendId: Friend.Id,
    source: String,
    order: Int,
    context: String? = nil
  ) {
    self.id = id
    self.friendId = friendId
    self.source = source
    self.order = order
    self.context = context
  }

}

// extensions

extension FriendQuote: AppModel {
  typealias Id = Tagged<FriendQuote, UUID>
}

extension FriendQuote: DuetModel {
  static let tableName = M12.tableName
}

extension FriendQuote: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case source
    case order
    case context
    case createdAt
    case updatedAt
  }
}

extension FriendQuote {
  enum M12 {
    static let tableName = "friend_quotes"
    static let friendId = FieldKey("friend_id")
    static let source = FieldKey("source")
    static let text = FieldKey("text")
    static let order = FieldKey("order")
    static let context = FieldKey("context")
  }
}
