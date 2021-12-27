// auto-generated, do not edit
import Foundation
import Tagged

extension DocumentTagModel: AppModel {
  typealias Id = Tagged<DocumentTagModel, UUID>
}

extension DocumentTagModel: DuetModel {
  static let tableName = M14.tableName
}

extension DocumentTagModel: DuetInsertable {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.slug]: .enum(slug),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension DocumentTagModel {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case slug
    case createdAt
  }
}

extension DocumentTagModel: Auditable {}
