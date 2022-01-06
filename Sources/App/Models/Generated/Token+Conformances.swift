// auto-generated, do not edit
import Foundation
import Tagged

extension Token: AppModel {
  typealias Id = Tagged<Token, UUID>
}

extension Token: DuetModel {
  static let tableName = M4.tableName
}

extension Token {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.value]: .uuid(value),
      Self[.description]: .string(description),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension Token {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case value
    case description
    case createdAt
  }
}

extension Token: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "value":
        return .uuid(value) == constraint.value
      case "description":
        return .string(description) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension Token: Auditable {}
