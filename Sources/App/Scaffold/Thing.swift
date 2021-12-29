import Foundation
import Tagged

final class Thing: Codable {
  var id: Id
}

extension Thing: AppModel {
  typealias Id = Tagged<Thing, UUID>
}

extension Thing: DuetModel {
  static let tableName = "things"
}

extension Thing {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
  }
}

extension Thing: DuetInsertable {
  var insertValues: [String: Postgres.Data] {
    [Self[.id]: .id(self)]
  }
}
