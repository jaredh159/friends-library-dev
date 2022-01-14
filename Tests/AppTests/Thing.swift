import Foundation
import Tagged

@testable import App

final class Thing: Codable {
  var id: Id
  var foo: String
  var bar: Int

  init(id: Id = .init(), foo: String = "foo", bar: Int = 123) {
    self.id = id
    self.foo = foo
    self.bar = bar
  }
}

// extensions

extension Thing: AppModel {
  typealias Id = Tagged<Thing, UUID>
}

extension Thing: DuetModel {
  static let tableName = "things"
}

extension Thing {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.foo]: .string(foo),
      Self[.bar]: .int(bar),
    ]
  }

  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case foo
    case bar
  }
}

extension Thing: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    true
  }
}
