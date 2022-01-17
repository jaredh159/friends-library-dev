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
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case code
    case editionId
    case createdAt
    case updatedAt
  }
}

extension Isbn {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .code: .string(code.rawValue),
      .editionId: .uuid(editionId),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Isbn: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Isbn>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .code:
        return .string(code.rawValue) == constraint.value
      case .editionId:
        return .uuid(editionId) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension Isbn: Auditable {}
extension Isbn: Touchable {}
