// auto-generated, do not edit
import DuetSQL
import Tagged

extension Friend: ApiModel {
  typealias Id = Tagged<Friend, UUID>
}

extension Friend: Model {
  static let tableName = M11.tableName
  static var isSoftDeletable: Bool { true }
}

extension Friend {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case lang
    case name
    case slug
    case gender
    case description
    case born
    case died
    case published
    case createdAt
    case updatedAt
    case deletedAt
  }
}

extension Friend {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .lang: .enum(lang),
      .name: .string(name),
      .slug: .string(slug),
      .gender: .enum(gender),
      .description: .string(description),
      .born: .int(born),
      .died: .int(died),
      .published: .date(published),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Friend: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Friend>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .lang:
        return constraint.isSatisfiedBy(.enum(lang))
      case .name:
        return constraint.isSatisfiedBy(.string(name))
      case .slug:
        return constraint.isSatisfiedBy(.string(slug))
      case .gender:
        return constraint.isSatisfiedBy(.enum(gender))
      case .description:
        return constraint.isSatisfiedBy(.string(description))
      case .born:
        return constraint.isSatisfiedBy(.int(born))
      case .died:
        return constraint.isSatisfiedBy(.int(died))
      case .published:
        return constraint.isSatisfiedBy(.date(published))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
      case .deletedAt:
        return constraint.isSatisfiedBy(.date(deletedAt))
    }
  }
}

extension Friend: Auditable {}
extension Friend: Touchable {}
