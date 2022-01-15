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
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case scope
    case tokenId
    case createdAt
  }
}

extension TokenScope {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .scope: .enum(scope),
      .tokenId: .uuid(tokenId),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension TokenScope: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "scope":
        return .enum(scope) == constraint.value
      case "token_id":
        return .uuid(tokenId) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension TokenScope: Auditable {}
