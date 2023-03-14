// auto-generated, do not edit
import DuetSQL
import Tagged

extension DocumentTag: ApiModel {
  typealias Id = Tagged<DocumentTag, UUID>
}

extension DocumentTag: Model {
  static let tableName = M15.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .documentId:
        return .uuid(documentId)
      case .type:
        return .enum(type)
      case .createdAt:
        return .date(createdAt)
    }
  }
}

extension DocumentTag {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case documentId
    case type
    case createdAt
  }
}

extension DocumentTag {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .documentId: .uuid(documentId),
      .type: .enum(type),
      .createdAt: .currentTimestamp,
    ]
  }
}
