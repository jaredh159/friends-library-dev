// auto-generated, do not edit
import DuetSQL
import Tagged

extension Edition: ApiModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: Model {
  static let tableName = M17.tableName
  static var isSoftDeletable: Bool { true }
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
        return constraint.isSatisfiedBy(.id(self))
      case .documentId:
        return constraint.isSatisfiedBy(.uuid(documentId))
      case .type:
        return constraint.isSatisfiedBy(.enum(type))
      case .editor:
        return constraint.isSatisfiedBy(.string(editor))
      case .isDraft:
        return constraint.isSatisfiedBy(.bool(isDraft))
      case .paperbackSplits:
        return constraint.isSatisfiedBy(.intArray(paperbackSplits?.array))
      case .paperbackOverrideSize:
        return constraint.isSatisfiedBy(.enum(paperbackOverrideSize))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
      case .deletedAt:
        return constraint.isSatisfiedBy(.date(deletedAt))
    }
  }
}

extension Edition: Auditable {}
extension Edition: Touchable {}
