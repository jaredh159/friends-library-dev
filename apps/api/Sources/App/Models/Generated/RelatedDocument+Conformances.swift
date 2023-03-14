// auto-generated, do not edit
import DuetSQL
import Tagged

extension RelatedDocument: ApiModel {
  typealias Id = Tagged<RelatedDocument, UUID>
}

extension RelatedDocument: Model {
  static let tableName = M23.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
    case .id:
      return .id(self)
    case .description:
      return .string(description)
    case .documentId:
      return .uuid(documentId)
    case .parentDocumentId:
      return .uuid(parentDocumentId)
    case .createdAt:
      return .date(createdAt)
    case .updatedAt:
      return .date(updatedAt)
    }
  }
}

extension RelatedDocument {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case description
    case documentId
    case parentDocumentId
    case createdAt
    case updatedAt
  }
}

extension RelatedDocument {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .description: .string(description),
      .documentId: .uuid(documentId),
      .parentDocumentId: .uuid(parentDocumentId),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}
