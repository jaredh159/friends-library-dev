// auto-generated, do not edit
import Foundation
import Tagged

extension FriendResidenceDuration: AppModel {
  typealias Id = Tagged<FriendResidenceDuration, UUID>
}

extension FriendResidenceDuration: DuetModel {
  static let tableName = M25.tableName
}

extension FriendResidenceDuration {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendResidenceId]: .uuid(friendResidenceId),
      Self[.start]: .int(start),
      Self[.end]: .int(end),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension FriendResidenceDuration {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendResidenceId
    case start
    case end
    case createdAt
  }
}

extension FriendResidenceDuration: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "friendResidenceId":
        return .uuid(friendResidenceId) == constraint.value
      case "start":
        return .int(start) == constraint.value
      case "end":
        return .int(end) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension FriendResidenceDuration: Auditable {}
