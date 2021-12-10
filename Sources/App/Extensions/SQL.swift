import FluentSQL
import Foundation

extension SQLRow {
  func decode<M: DuetModel>(_ type: M.Type) throws -> M {
    try decode(model: M.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
  }
}

extension SQLQueryString {
  mutating func appendInterpolation<T: RawRepresentable>(id: T) where T.RawValue == UUID {
    self.appendInterpolation(raw: id.rawValue.uuidString)
  }

  mutating func appendInterpolation<M: DuetModel>(table model: M.Type) {
    self.appendInterpolation(raw: model.tableName)
  }

  mutating func appendInterpolation(col: String) {
    self.appendInterpolation(raw: col)
  }

  mutating func appendInterpolation(nullable: String?) {
    if let string = nullable {
      self.appendInterpolation(raw: "'")
      self.appendInterpolation(raw: string)
      self.appendInterpolation(raw: "'")
    } else {
      self.appendInterpolation(raw: "NULL")
    }
  }

  mutating func appendInterpolation(nullable: Int?) {
    if let string = nullable {
      self.appendInterpolation(literal: string)
    } else {
      self.appendInterpolation(raw: "NULL")
    }
  }
}
