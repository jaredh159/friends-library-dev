// auto-generated, do not edit
import Foundation
import Tagged

extension Friend: AppModel {
  typealias Id = Tagged<Friend, UUID>
}

extension Friend: DuetModel {
  static let tableName = M10.tableName
}

extension Friend: DuetInsertable {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.lang]: .enum(lang),
      Self[.name]: .string(name),
      Self[.slug]: .string(slug),
      Self[.gender]: .enum(gender),
      Self[.description]: .string(description),
      Self[.born]: .int(born),
      Self[.died]: .int(died),
      Self[.published]: .enum(published),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension Friend {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case lang
    case name
    case slug
    case gender
    case description
    case born
    case died
    case published
    case createdAt
    case updatedAt
  }
}

extension Friend: Auditable {}
extension Friend: Touchable {}
