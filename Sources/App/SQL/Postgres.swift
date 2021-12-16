import Foundation

protocol PostgresEnum {
  var dataType: String { get }
  var rawValue: String { get }
}

enum Postgres {

  enum Columns {
    case all
    case columns([String])

    var sql: String {
      switch self {
        case .all:
          return "*"
        case .columns(let columns):
          return "\"\(columns.joined(separator: "\", \""))\""
      }
    }
  }

  enum WhereOperator {
    case equals

    var sql: String {
      switch self {
        case .equals:
          return "="
      }
    }
  }

  enum Data {
    case id(UUIDIdentifiable)
    case string(String?)
    case int(Int?)
    case float(Float?)
    case double(Double?)
    case uuid(UUIDStringable?)
    case bool(Bool?)
    case date(Date?)
    case `enum`(PostgresEnum?)
    case currentTimestamp

    var typeName: String {
      switch self {
        case .string:
          return "text"
        case .int, .double, .float:
          return "numeric"
        case .uuid, .id:
          return "uuid"
        case .bool:
          return "bool"
        case .enum(let enumVal):
          return enumVal?.dataType ?? "unknown"
        case .date:
          return "timestamp"
        case .currentTimestamp:
          return "timestamp"
      }
    }

    var param: String {
      switch self {
        case let .enum(enumVal):
          return nullable(enumVal?.rawValue)
        case let .string(string):
          return nullable(string)
        case let .int(int):
          return nullable(int)
        case let .float(float):
          return nullable(float)
        case let .double(double):
          return nullable(double)
        case let .id(model):
          return "'\(model.uuidId.uuidString)'"
        case let .uuid(uuid):
          return nullable(uuid?.uuidString)
        case let .bool(bool):
          return nullable(bool)
        case let .date(date):
          return nullable(date)
        case .currentTimestamp:
          return "current_timestamp"
      }
    }
  }
}

private func nullable(_ string: String?) -> String {
  switch string {
    case nil:
      return "NULL"
    case .some(let string):
      return "'\(string)'"
  }
}

private func nullable(_ bool: Bool?) -> String {
  switch bool {
    case nil:
      return "NULL"
    case .some(let bool):
      return bool ? "true" : "false"
  }
}

private func nullable(_ date: Date?) -> String {
  switch date {
    case nil:
      return "NULL"
    case .some(let date):
      return "'\(date.isoString)'"
  }
}

private func nullable<N: Numeric>(_ string: N?) -> String {
  switch string {
    case nil:
      return "NULL"
    case .some(let number):
      return "\(number)"
  }
}

extension Postgres.Data: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    self = .string(value)
  }
}

extension Postgres.Data: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self = .int(value)
  }
}

extension Postgres.Data: ExpressibleByBooleanLiteral {
  init(booleanLiteral value: Bool) {
    self = .bool(value)
  }
}

extension Postgres.Data: Equatable {
  static func == (lhs: Postgres.Data, rhs: Postgres.Data) -> Bool {
    [lhs.typeName, lhs.param] == [rhs.typeName, rhs.param]
  }
}
