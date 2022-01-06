// auto-generated, do not edit
import Foundation
import Tagged

extension Isbn: AppModel {
  typealias Id = Tagged<Isbn, UUID>
}

extension Isbn: DuetModel {
  static let tableName = M19.tableName
}

extension Isbn {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.code]: .string(code.rawValue),
      Self[.editionId]: .uuid(editionId),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension Isbn {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case code
    case editionId
    case createdAt
    case updatedAt
  }
}

extension Isbn: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "code":
        return .string(code.rawValue) == constraint.value
      case "editionId":
        return .uuid(editionId) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      case "updatedAt":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension Isbn: Auditable {}
extension Isbn: Touchable {}
