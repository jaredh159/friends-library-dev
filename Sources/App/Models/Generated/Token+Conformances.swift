// auto-generated, do not edit
import Foundation
import Tagged

extension Token: AppModel {
  typealias Id = Tagged<Token, UUID>
}

extension Token: DuetModel {
  static let tableName = M4.tableName
}

extension Token {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.value]: .uuid(value),
      Self[.description]: .string(description),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension Token {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case value
    case description
    case createdAt
  }
}

extension Token: Auditable {}
