// auto-generated, do not edit
import Foundation
import Tagged

extension TokenScope: ApiModel {
  typealias Id = Tagged<TokenScope, UUID>
}

extension TokenScope: DuetModel {
  static let tableName = M5.tableName
}

extension TokenScope {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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
  func satisfies(constraint: SQL.WhereConstraint<TokenScope>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .scope:
        return .enum(scope) == constraint.value
      case .tokenId:
        return .uuid(tokenId) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
    }
  }
}

extension TokenScope: Auditable {}
