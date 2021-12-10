import FluentSQL
import Foundation

extension SQLRow {
  func decode<M: AltModel>(_ type: M.Type) throws -> M {
    try decode(model: M.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
  }
}

extension SQLQueryString {
  mutating func appendInterpolation<T: RawRepresentable>(id: T) where T.RawValue == UUID {
    self.appendInterpolation(raw: id.rawValue.uuidString)
  }

  mutating func appendInterpolation<M: AltModel>(table model: M.Type) {
    self.appendInterpolation(raw: model.tableName)
  }

  mutating func appendInterpolation(col: String) {
    self.appendInterpolation(raw: col)
  }
}
