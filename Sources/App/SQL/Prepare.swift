import FluentSQL
import Foundation

protocol PostgresEnum {
  var dataType: String { get }
  var rawValue: String { get }
}

enum DataType {
  case string(String?)
  case int(Int?)
  case float(Float?)
  case double(Double?)
  case uuid(UUID?)
  // case lol(DuetModel.IdValue)
  case bool(Bool?)
  case date(Date?)
  case `enum`(PostgresEnum?)
  case currentTimestamp
}

typealias PreparedStatement = (name: String, prepare: String, execute: String)

private var prepared: Set<String> = []

func execute(_ statement: PreparedStatement, on db: SQLDatabase) -> Future<SQLRawBuilder> {
  let prepareFuture: Future<[SQLRow]>
  if prepared.contains(statement.name) {
    prepareFuture = db.eventLoop.makeSucceededFuture([])
  } else {
    prepared.insert(statement.name)
    prepareFuture = db.raw("\(raw: statement.prepare)").all()
  }
  return prepareFuture.map { _ in
    db.raw("\(raw: statement.execute)")
  }
}

func insert(
  into table: String,
  values: [String: DataType],
  as name: String? = nil
) -> PreparedStatement {
  let statement = name ?? "insert_\(table.dropLast())"
  var dataTypes: [String] = []
  var columns: [String] = []
  var bindings: [String] = []
  var params: [String] = []
  var currentBinding = 1

  for (column, value) in values {
    columns.append(column)
    bindings.append("$\(currentBinding)")
    currentBinding += 1
    switch value {
      case let .enum(enumVal):
        dataTypes.append(enumVal?.dataType ?? "unknown")
        params.append(nullable(enumVal?.rawValue))
      case let .string(string):
        dataTypes.append("text")
        params.append(nullable(string))
      case let .int(int):
        dataTypes.append("numeric")
        params.append(nullable(int))
      case let .float(float):
        dataTypes.append("numeric")
        params.append(nullable(float))
      case let .double(double):
        dataTypes.append("numeric")
        params.append(nullable(double))
      case let .uuid(uuid):
        dataTypes.append("uuid")
        params.append(nullable(uuid?.uuidString))
      case let .bool(bool):
        dataTypes.append("boolean")
        params.append(nullable(bool))
      case let .date(date):
        dataTypes.append("timestamp")
        params.append(nullable(date))
      case .currentTimestamp:
        dataTypes.append("timestamp")
        params.append("current_timestamp")
    }
  }

  let columnNames = #"("\#(columns.joined(separator: "\", \""))")"#
  let values = "(\(bindings.joined(separator: ", ")))"

  let prepare = """
    PREPARE \(statement)(\(dataTypes.joined(separator: ", "))) AS
      INSERT INTO "\(table)" \(columnNames) VALUES \(values);
    """

  let execute = """
    EXECUTE \(statement)(\(params.joined(separator: ", ")));
    """

  return (statement, prepare, execute)
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
