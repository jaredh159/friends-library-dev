// auto-generated, do not edit
import Foundation
import Tagged

extension Isbn: AppModel {
  typealias Id = Tagged<Isbn, UUID>
}

extension Isbn: DuetModel {
  static let tableName = M18.tableName
}

extension Isbn: DuetInsertable {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.code]: .string(code.rawValue),
      Self[.editionId]: .enum(editionId),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension Isbn {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case code
    case editionId
    case createdAt
    case updatedAt
  }
}

extension Isbn: Auditable {}
extension Isbn: Touchable {}
