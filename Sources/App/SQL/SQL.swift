import FluentSQL
import Foundation

private var prepared: [String: String] = [:]

enum SQL {
  typealias WhereConstraint = (
    column: String,
    operator: Postgres.WhereOperator,
    value: Postgres.Data
  )

  enum OrderDirection {
    case asc
    case desc

    var sql: String {
      switch self {
        case .asc:
          return "ASC"
        case .desc:
          return "DESC"
      }
    }
  }

  struct Order<M: DuetModel> {
    let column: M.ColumnName
    let direction: OrderDirection
  }

  struct PreparedStatement {
    let query: String
    let bindings: [Postgres.Data]
  }

  static func delete(
    from table: String,
    where constraints: [WhereConstraint]? = nil
  ) -> PreparedStatement {
    var binding = 1
    var bindings: [Postgres.Data] = []

    let WHERE = whereClause(
      constraints,
      currentBinding: &binding,
      bindings: &bindings,
      separatedBy: " "
    )

    let query = #"DELETE FROM "\#(table)"\#(WHERE);"#
    return PreparedStatement(query: query, bindings: bindings)
  }

  static func update(
    _ table: String,
    set values: [String: Postgres.Data],
    where constraints: [WhereConstraint]? = nil,
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

    let WHERE = whereClause(constraints, currentBinding: &currentBinding, bindings: &bindings)

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

  static func select<M: DuetModel>(
    _ columns: Postgres.Columns,
    from Model: M.Type,
    where constraints: [WhereConstraint] = [],
    orderBy order: Order<M>? = nil,
    limit: Int? = nil
  ) -> PreparedStatement {
    var binding = 1
    var bindings: [Postgres.Data] = []
    let WHERE = whereClause(constraints, currentBinding: &binding, bindings: &bindings)

    var ORDER_BY = ""
    if let order = order {
      ORDER_BY = "\nORDER BY \"\(M.columnName(order.column))\" \(order.direction.sql)"
    }

    var LIMIT = ""
    if let limit = limit {
      LIMIT = "\nLIMIT \(limit)"
    }

    let query = """
    SELECT \(columns.sql) FROM "\(M.tableName)"\(WHERE)\(ORDER_BY)\(LIMIT);
    """

    return PreparedStatement(query: query, bindings: bindings)
  }

  static func execute(
    _ statement: PreparedStatement,
    on db: SQLDatabase
  ) async throws -> SQLRawBuilder {
    // e.g. SELECT statements with no WHERE clause have
    // no bindings, and so can't be sent as a pg prepared statement
    if statement.bindings.isEmpty {
      return db.raw("\(raw: statement.query)")
    }

    let types = statement.bindings.map(\.typeName).list
    let params = statement.bindings.map(\.param).list
    let key = [statement.query, types].joined()
    let name: String

    if let previouslyInsertedName = prepared[key] {
      name = previouslyInsertedName
    } else {
      let id = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
      name = "plan_\(id)"
      let insertPrepareSql = """
      PREPARE \(name)(\(types)) AS
      \(statement.query)
      """
      prepared[key] = name
      _ = try await db.raw("\(raw: insertPrepareSql)").all().get()
    }

    return db.raw("\(raw: "EXECUTE \(name)(\(params))")")
  }

  private static func whereClause(
    _ constraints: [WhereConstraint]?,
    currentBinding binding: inout Int,
    bindings: inout [Postgres.Data],
    separatedBy: String = "\n"
  ) -> String {
    guard let constraints = constraints, !constraints.isEmpty else { return "" }
    var parts: [String] = []
    for (index, constraint) in constraints.enumerated() {
      let prefix = index == 0 ? "WHERE" : "AND"
      bindings.append(constraint.value)
      parts.append("\(prefix) \"\(constraint.column)\" \(constraint.operator.sql) $\(binding)")
      binding += 1
    }
    return "\(separatedBy)\(parts.joined(separator: separatedBy))"
  }

  static func resetPreparedStatements() {
    prepared = [:]
  }
}

private extension Sequence where Element == String {
  var list: String {
    joined(separator: ", ")
  }

  var quotedList: String {
    "\"\(joined(separator: "\", \""))\""
  }
}

func == (lhs: String, rhs: Postgres.Data) -> SQL.WhereConstraint {
  (lhs, .equals, rhs)
}

func == (lhs: String, rhs: UUIDStringable) -> SQL.WhereConstraint {
  (lhs, .equals, .uuid(rhs))
}
