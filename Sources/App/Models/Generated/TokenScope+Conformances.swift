// auto-generated, do not edit
import DuetSQL
import Tagged

extension TokenScope: ApiModel {
  typealias Id = Tagged<TokenScope, UUID>
}

extension TokenScope: Model {
  static let tableName = M5.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .scope:
        return constraint.isSatisfiedBy(.enum(scope))
      case .tokenId:
        return constraint.isSatisfiedBy(.uuid(tokenId))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension TokenScope: Auditable {}
