// auto-generated, do not edit
import DuetSQL
import Tagged

extension Edition: ApiModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: Model {
  static let tableName = M17.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .documentId:
        return .uuid(documentId)
      case .type:
        return .enum(type)
      case .editor:
        return .string(editor)
      case .isDraft:
        return .bool(isDraft)
      case .paperbackSplits:
        return .intArray(paperbackSplits?.array)
      case .paperbackOverrideSize:
        return .enum(paperbackOverrideSize)
      case .createdAt:
        return .date(createdAt)
      case .updatedAt:
        return .date(updatedAt)
      case .deletedAt:
        return .date(deletedAt)
    }
  }
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
