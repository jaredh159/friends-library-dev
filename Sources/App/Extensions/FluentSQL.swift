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
