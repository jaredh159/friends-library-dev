// auto-generated, do not edit
import DuetSQL
import Tagged

extension Isbn: ApiModel {
  typealias Id = Tagged<Isbn, UUID>
}

extension Isbn: Model {
  static let tableName = M19.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
    case .id:
      return .id(self)
    case .code:
      return .string(code.rawValue)
    case .editionId:
      return .uuid(editionId)
    case .createdAt:
      return .date(createdAt)
    case .updatedAt:
      return .date(updatedAt)
    }
  }
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
