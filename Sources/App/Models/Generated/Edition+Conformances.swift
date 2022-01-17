// auto-generated, do not edit
import Foundation
import Tagged

extension Edition: AppModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: DuetModel {
  static let tableName = M17.tableName
}

extension Edition {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case documentId
    case type
    case editor
    case isDraft
    case paperbackSplits
    case paperbackOverrideSize
    case createdAt
    case updatedAt
    case deletedAt
  }
}

extension Edition {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .documentId: .uuid(documentId),
      .type: .enum(type),
      .editor: .string(editor),
      .isDraft: .bool(isDraft),
      .paperbackSplits: .intArray(paperbackSplits?.array),
      .paperbackOverrideSize: .enum(paperbackOverrideSize),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Edition: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Edition>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .documentId:
        return .uuid(documentId) == constraint.value
      case .type:
        return .enum(type) == constraint.value
      case .editor:
        return .string(editor) == constraint.value
      case .isDraft:
        return .bool(isDraft) == constraint.value
      case .paperbackSplits:
        return .intArray(paperbackSplits?.array) == constraint.value
      case .paperbackOverrideSize:
        return .enum(paperbackOverrideSize) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
      case .deletedAt:
        return .date(deletedAt) == constraint.value
    }
  }
}

extension Edition: Auditable {}
extension Edition: Touchable {}
