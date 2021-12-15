import FluentSQL
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

typealias PreparedStatement = (name: String, prepare: String, execute: String)

private var prepared: [String: String] = [:]

func execute(_ statement: PreparedStatement, on db: SQLDatabase) throws -> Future<SQLRawBuilder> {
  let prepareFuture: Future<[SQLRow]>
  if prepared[statement.name] == statement.prepare {
    prepareFuture = db.eventLoop.makeSucceededFuture([])
  } else if prepared[statement.name] != nil {
    throw DbError.preparedStatementNameCollision
  } else {
    prepared[statement.name] = statement.prepare
    prepareFuture = db.raw("\(raw: statement.prepare)").all()
  }
  return prepareFuture.map { _ in
    db.raw("\(raw: statement.execute)")
  }
}

func insert(
  into table: String,
  values: [String: Postgres.Data],
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
    dataTypes.append(value.typeName)
    params.append(value.param)
    bindings.append("$\(currentBinding)")
    currentBinding += 1
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

func select<Model: DuetModel>(
  _ columns: Postgres.Columns,
  from model: Model.Type,
  where: (String, Postgres.WhereOperator, Postgres.Data),
  as name: String? = nil
) -> PreparedStatement {
  let table = model.tableName
  let (whereCol, whereOp, whereParam) = `where`
  let name = name ?? "select_\(table.dropLast())"

  let prepare = """
    PREPARE \(name)(\(whereParam.typeName)) AS
      SELECT \(columns.sql) from "\(table)"
      WHERE "\(whereCol)" \(whereOp.sql) $1;
    """

  let execute = "EXECUTE \(name)(\(whereParam.param))"
  return (name, prepare, execute)
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
