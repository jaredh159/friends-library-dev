// auto-generated, do not edit
import Foundation
import Tagged

extension DocumentTagModel: AppModel {
  typealias Id = Tagged<DocumentTagModel, UUID>
}

extension DocumentTagModel: DuetModel {
  static let tableName = M15.tableName
}

extension DocumentTagModel {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.slug]: .enum(slug),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension DocumentTagModel {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case slug
    case createdAt
  }
}

extension DocumentTagModel: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "slug":
        return .enum(slug) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension DocumentTagModel: Auditable {}
