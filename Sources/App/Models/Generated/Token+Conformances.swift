// auto-generated, do not edit
import Foundation
import Tagged

extension Token: ApiModel {
  typealias Id = Tagged<Token, UUID>
}

extension Token: DuetModel {
  static let tableName = M4.tableName
  static var isSoftDeletable: Bool { false }
}

extension Token {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case value
    case description
    case uses
    case createdAt
  }
}

extension Token {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .value: .uuid(value),
      .description: .string(description),
      .uses: .int(uses),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension Token: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Token>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .value:
        return constraint.isSatisfiedBy(.uuid(value))
      case .description:
        return constraint.isSatisfiedBy(.string(description))
      case .uses:
        return constraint.isSatisfiedBy(.int(uses))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension Token: Auditable {}
