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
    let query: String
    let bindings: [Postgres.Data]
  }

  static func update(
    _ table: String,
    set values: [String: Postgres.Data],
    where constraint: WhereConstraint? = nil,
    returning: Postgres.Columns? = nil
  ) -> PreparedStatement {
    var bindings: [Postgres.Data] = []
    var setPairs: [String] = []
    var currentBinding = 1

    for (column, value) in values {
      bindings.append(value)
      setPairs.append("\"\(column)\" = $\(currentBinding)")
      currentBinding += 1
    }

    var WHERE = ""
    if let constraint = constraint {
      bindings.append(constraint.value)
      WHERE = "\n\(whereClause(constraint, boundTo: currentBinding))"
    }

    var RETURNING = ""
    if let returning = returning {
      RETURNING = "\nRETURNING \(returning.sql)"
    }

    let query = """
      UPDATE "\(table)"
      SET \(setPairs.list)\(WHERE)\(RETURNING);
      """

    return PreparedStatement(query: query, bindings: bindings)
  }

  static func insert(
    into table: String,
    values: [String: Postgres.Data]
  ) throws -> PreparedStatement {
    try insert(into: table, values: [values])
  }

  static func insert(
    into table: String,
    values: [[String: Postgres.Data]]
  ) throws -> PreparedStatement {
    guard let firstRecord = values.first else {
      throw DbError.emptyBulkInsertInput
    }

    guard values.allSatisfy({ $0.keys.sorted() == firstRecord.keys.sorted() }) else {
      throw DbError.nonUniformBulkInsertInput
    }

    let columns = Array(firstRecord.keys.sorted())
    var placeholderGroups: [String] = []
    var bindings: [Postgres.Data] = []
    var currentBinding = 1

    for record in values {
      var placeholders: [String] = []
      for key in record.keys.sorted() {
        bindings.append(record[key]!)
        placeholders.append("$\(currentBinding)")
        currentBinding += 1
      }
      placeholderGroups.append("(\(placeholders.list))")
    }

    let query = """
      INSERT INTO "\(table)"
      (\(columns.quotedList))
      VALUES
      \(placeholderGroups.list);
      """

    return PreparedStatement(query: query, bindings: bindings)
  }

  static func select(
    _ columns: Postgres.Columns,
    from table: String,
    where constraint: WhereConstraint
  ) -> PreparedStatement {
    let query = """
      SELECT \(columns.sql) from "\(table)"
      \(whereClause(constraint, boundTo: 1));
      """

    return PreparedStatement(query: query, bindings: [constraint.value])
  }

  static func execute(
    _ statement: PreparedStatement,
    on db: SQLDatabase
  ) throws -> Future<SQLRawBuilder> {
    let types = statement.bindings.map(\.typeName).list
    let params = statement.bindings.map(\.param).list
    let key = [statement.query, types].joined()
    let prepareFuture: Future<[SQLRow]>
    let name: String

    if let previouslyInsertedName = prepared[key] {
      name = previouslyInsertedName
      prepareFuture = db.eventLoop.makeSucceededFuture([])
    } else {
      let id = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
      name = "plan_\(id)"
      let insertPrepareSql = """
        PREPARE \(name)(\(types)) AS
        \(statement.query)
        """
      prepared[key] = name
      prepareFuture = db.raw("\(raw: insertPrepareSql)").all()
    }

    return prepareFuture.map { _ in
      db.raw("\(raw: "EXECUTE \(name)(\(params))")")
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
