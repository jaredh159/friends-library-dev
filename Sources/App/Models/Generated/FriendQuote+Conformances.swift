// auto-generated, do not edit
import Foundation
import Tagged

extension FriendQuote: AppModel {
  typealias Id = Tagged<FriendQuote, UUID>
}

extension FriendQuote: DuetModel {
  static let tableName = M13.tableName
}

extension FriendQuote {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case source
    case text
    case order
    case context
    case createdAt
    case updatedAt
  }
}

extension FriendQuote {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .friendId: .uuid(friendId),
      .source: .string(source),
      .text: .string(text),
      .order: .int(order),
      .context: .string(context),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension FriendQuote: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "friend_id":
        return .uuid(friendId) == constraint.value
      case "source":
        return .string(source) == constraint.value
      case "text":
        return .string(text) == constraint.value
      case "order":
        return .int(order) == constraint.value
      case "context":
        return .string(context) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension FriendQuote: Auditable {}
extension FriendQuote: Touchable {}
