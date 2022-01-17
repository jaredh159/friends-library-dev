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
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case friendResidenceId
    case start
    case end
    case createdAt
  }
}

extension FriendResidenceDuration {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .friendResidenceId: .uuid(friendResidenceId),
      .start: .int(start),
      .end: .int(end),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension FriendResidenceDuration: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<FriendResidenceDuration>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .friendResidenceId:
        return .uuid(friendResidenceId) == constraint.value
      case .start:
        return .int(start) == constraint.value
      case .end:
        return .int(end) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
    }
  }
}

extension FriendResidenceDuration: Auditable {}
