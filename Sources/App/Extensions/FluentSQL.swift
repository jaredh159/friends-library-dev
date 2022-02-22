import FluentSQL
import Foundation

extension SQLRow {
  func decode<M: DuetModel>(_ type: M.Type) throws -> M {
    try decode(model: M.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
  }
}

extension SQLQueryString {
  mutating func appendInterpolation<T: RawRepresentable>(id: T) where T.RawValue == UUID {
    appendInterpolation(raw: id.rawValue.uuidString)
  }

  mutating func appendInterpolation<M: DuetModel>(table model: M.Type) {
    appendInterpolation(raw: model.tableName)
  }

  mutating func appendInterpolation(col: String) {
    appendInterpolation(raw: col)
  }

  mutating func appendInterpolation(nullable: String?) {
    if let string = nullable {
      appendInterpolation(raw: "'")
      appendInterpolation(raw: string)
      appendInterpolation(raw: "'")
    } else {
      appendInterpolation(raw: "NULL")
    }
  }

  mutating func appendInterpolation(nullable: Int?) {
    if let string = nullable {
      appendInterpolation(literal: string)
    } else {
      appendInterpolation(raw: "NULL")
    }
  }
}

extension Migration {
  // doing the documented way of database.enum().case().update()
  // seems to only update _fluent_enums, without affecting underlying PG enum type
  // at least when doing multiple cases, so, we do it manually
  func addDbEnumCases(
    fixingPriorIncompleteMigration completingPriorMigration: Bool = false,
    db: Database,
    enumName: String,
    newCases: [String]
  ) async throws {
    let sql = db as! SQLDatabase

    for newCase in newCases {
      if !completingPriorMigration {
        _ = try await sql.raw(
          """
          INSERT INTO "_fluent_enums"
          ("id", "name", "case")
          VALUES
          ('\(raw: UUID().lowercased)', '\(raw: enumName)', '\(raw: newCase)');
          """
        ).all()
      }

      _ = try await sql.raw("ALTER TYPE \(raw: enumName) ADD VALUE '\(raw: newCase)';").all()
    }
  }
}
