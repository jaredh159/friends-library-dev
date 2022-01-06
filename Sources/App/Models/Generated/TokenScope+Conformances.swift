// auto-generated, do not edit
import Foundation
import Tagged

extension TokenScope: AppModel {
  typealias Id = Tagged<TokenScope, UUID>
}

extension TokenScope: DuetModel {
  static let tableName = M5.tableName
}

extension TokenScope {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.scope]: .enum(scope),
      Self[.tokenId]: .uuid(tokenId),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension TokenScope {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case scope
    case tokenId
    case createdAt
  }
}

extension TokenScope: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "scope":
        return .enum(scope) == constraint.value
      case "tokenId":
        return .uuid(tokenId) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension TokenScope: Auditable {}
