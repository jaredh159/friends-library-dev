// auto-generated, do not edit
import Foundation
import Tagged

extension FriendResidence: AppModel {
  typealias Id = Tagged<FriendResidence, UUID>
}

extension FriendResidence: DuetModel {
  static let tableName = M12.tableName
}

extension FriendResidence {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendId]: .uuid(friendId),
      Self[.city]: .string(city),
      Self[.region]: .string(region),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension FriendResidence {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case city
    case region
    case createdAt
    case updatedAt
  }
}

extension FriendResidence: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "friend_id":
        return .uuid(friendId) == constraint.value
      case "city":
        return .string(city) == constraint.value
      case "region":
        return .string(region) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension FriendResidence: Auditable {}
extension FriendResidence: Touchable {}
