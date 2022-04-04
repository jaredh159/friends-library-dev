// auto-generated, do not edit
import DuetSQL
import Tagged

extension FriendResidenceDuration: ApiModel {
  typealias Id = Tagged<FriendResidenceDuration, UUID>
}

extension FriendResidenceDuration: Model {
  static let tableName = M25.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .friendResidenceId:
        return constraint.isSatisfiedBy(.uuid(friendResidenceId))
      case .start:
        return constraint.isSatisfiedBy(.int(start))
      case .end:
        return constraint.isSatisfiedBy(.int(end))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension FriendResidenceDuration: Auditable {}
