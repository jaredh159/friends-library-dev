import FluentSQL
import Foundation

private var prepared: [String: String] = [:]

enum SQL {
  typealias WhereConstraint = (
    column: String,
    operator: Postgres.WhereOperator,
    value: Postgres.Data
  )

  struct PreparedStatement {
    let name: String
    let prepare: String
    let execute: String
  }

  static func resetPrepared() {
    prepared = [:]
  }

  static func update(
    _ table: String,
    set values: [String: Postgres.Data],
    where constraint: WhereConstraint? = nil,
    returning: Postgres.Columns? = nil,
    as name: String = #function
  ) -> PreparedStatement {
    let name = name.replace(#"[^A-Za-z]"#, "")
    var paramTypes: [String] = []
    var setPairs: [String] = []
    var params: [String] = []
    var currentBinding = 1

    for (column, value) in values {
      paramTypes.append(value.typeName)
      params.append(value.param)
      setPairs.append("\"\(column)\" = $\(currentBinding)")
      currentBinding += 1
    }

    var WHERE = ""
    if let constraint = constraint {
      paramTypes.append(constraint.value.typeName)
      params.append(constraint.value.param)
      WHERE = "\n  \(whereClause(constraint, boundTo: currentBinding))"
    }

    var RETURNING = ""
    if let returning = returning {
      RETURNING = "\n  RETURNING \(returning.sql)"
    }

    let prepare = """
      PREPARE \(name)(\(paramTypes.list)) AS
        UPDATE "\(table)"
        SET \(setPairs.list)\(WHERE)\(RETURNING);
      """

    let execute = "EXECUTE \(name)(\(params.list));"

    return PreparedStatement(name: name, prepare: prepare, execute: execute)
  }

  static func insert(
    into table: String,
    values: [String: Postgres.Data],
    as name: String = #function
  ) -> PreparedStatement {
    let name = name.replace(#"[^A-Za-z]"#, "")
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

    let prepare = """
      PREPARE \(name)(\(dataTypes.list)) AS
        INSERT INTO "\(table)" (\(columns.quotedList)) VALUES (\(bindings.list));
      """

    let execute = "EXECUTE \(name)(\(params.list));"

    return PreparedStatement(name: name, prepare: prepare, execute: execute)
  }

  static func select(
    _ columns: Postgres.Columns,
    from table: String,
    where constraint: WhereConstraint,
    as name: String = #function
  ) -> PreparedStatement {
    let name = name.replace(#"[^A-Za-z]"#, "")

    let prepare = """
      PREPARE \(name)(\(constraint.value.typeName)) AS
        SELECT \(columns.sql) from "\(table)"
        \(whereClause(constraint, boundTo: 1));
      """

    let execute = "EXECUTE \(name)(\(constraint.value.param))"
    return PreparedStatement(name: name, prepare: prepare, execute: execute)
  }

  static func execute(
    _ statement: PreparedStatement,
    on db: SQLDatabase
  ) throws -> Future<SQLRawBuilder> {
    let prepareFuture: Future<[SQLRow]>
    if prepared[statement.name] == statement.prepare {
      prepareFuture = db.eventLoop.makeSucceededFuture([])
    } else if prepared[statement.name] != nil {
      print("\n\n\n")
      print(statement.name)
      print("----")
      print(prepared[statement.name]!)
      print("----")
      print(statement.prepare)
      print("----")
      print(prepared[statement.name] == Optional<String>.some(statement.prepare))
      print("----")
      throw DbError.preparedStatementNameCollision
    } else {
      prepared[statement.name] = statement.prepare
      prepareFuture = db.raw("\(raw: statement.prepare)").all()
    }
    return prepareFuture.map { _ in
      db.raw("\(raw: statement.execute)")
    }
  }

  private static func whereClause(_ constraint: WhereConstraint, boundTo binding: Int) -> String {
    "WHERE \"\(constraint.column)\" \(constraint.operator.sql) $\(binding)"
  }
}

extension Sequence where Element == String {
  fileprivate var list: String {
    self.joined(separator: ", ")
  }

  fileprivate var quotedList: String {
    "\"\(self.joined(separator: "\", \""))\""
  }
}
