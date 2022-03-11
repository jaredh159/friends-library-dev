import FluentSQL
import Foundation
import NonEmpty
import Vapor

enum SQL {
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

    init(column: M.ColumnName, direction: OrderDirection) {
      self.column = column
      self.direction = direction
    }

    init(_ column: M.ColumnName, _ direction: OrderDirection) {
      self.column = column
      self.direction = direction
    }

    static func sql(_ order: Self?, prefixedBy prefix: String = "\n") -> String {
      guard let order = order else { return "" }
      return "\(prefix)ORDER BY \"\(M.columnName(order.column))\" \(order.direction.sql)"
    }
  }

  struct WhereConstraint<M: DuetModel> {
    enum Expression {
      case equals(Postgres.Data)
      case `in`([Postgres.Data])
      case notIn([Postgres.Data])
      case isNull
      case notNull
    }

    let column: M.ColumnName
    let expression: Expression

    static func isNull(_ column: M.ColumnName) -> Self {
      .init(column: column, expression: .isNull)
    }

    static func notNull(_ column: M.ColumnName) -> Self {
      .init(column: column, expression: .notNull)
    }

    func sql(boundTo bindings: inout [Postgres.Data]) -> String {
      switch expression {
        case .isNull:
          return "\"\(M.columnName(column))\" IS NULL"
        case .notNull:
          return "\"\(M.columnName(column))\" NOT NULL"
        case .equals(let value):
          bindings.append(value)
          return "\"\(M.columnName(column))\" = $\(bindings.count)"
        case .notIn(let values):
          guard !values.isEmpty else { return "TRUE" }
          var placeholders: [String] = []
          for value in values {
            bindings.append(value)
            placeholders.append("$\(bindings.count)")
          }
          return "\"\(M.columnName(column))\" NOT IN (\(placeholders.list))"
        case .in(let values):
          guard !values.isEmpty else { return "FALSE" }
          var placeholders: [String] = []
          for value in values {
            bindings.append(value)
            placeholders.append("$\(bindings.count)")
          }
          return "\"\(M.columnName(column))\" IN (\(placeholders.list))"
      }
    }
  }

  struct PreparedStatement {
    let query: String
    let bindings: [Postgres.Data]
  }

  static func delete<M: DuetModel>(
    from Model: M.Type,
    where constraints: [WhereConstraint<M>]? = nil,
    orderBy: Order<M>? = nil,
    limit: Int? = nil
  ) -> PreparedStatement {
    var bindings: [Postgres.Data] = []
    let WHERE = whereClause(constraints, bindings: &bindings)
    let ORDER_BY = Order<M>.sql(orderBy)
    let LIMIT = limit.sql()
    let query = #"DELETE FROM "\#(Model.tableName)"\#(WHERE)\#(ORDER_BY)\#(LIMIT);"#
    return PreparedStatement(query: query, bindings: bindings)
  }

  static func softDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [WhereConstraint<M>]? = nil
  ) -> PreparedStatement {
    update(table: M.tableName, set: ["deleted_at": .currentTimestamp], where: constraints)
  }

  private static func update<M: DuetModel>(
    table: String,
    set values: [String: Postgres.Data],
    where constraints: [WhereConstraint<M>]? = nil,
    returning: Postgres.Columns? = nil
  ) -> PreparedStatement {
    var bindings: [Postgres.Data] = []
    var setPairs: [String] = []

    for (column, value) in values.filter({ key, _ in key != "created_at" && key != "id" }) {
      bindings.append(value)
      setPairs.append("\"\(column)\" = $\(bindings.count)")
    }

    let WHERE = whereClause(constraints, bindings: &bindings)

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

  static func update<M: DuetModel>(
    _ Model: M.Type,
    set values: [M.ColumnName: Postgres.Data],
    where constraints: [WhereConstraint<M>]? = nil,
    returning: Postgres.Columns? = nil
  ) -> PreparedStatement {
    update(
      table: M.tableName,
      set: values.mapKeys { M.columnName($0) },
      where: constraints,
      returning: returning
    )
  }

  static func insert<M: DuetModel>(
    into Model: M.Type,
    values: [M.ColumnName: Postgres.Data]
  ) throws -> PreparedStatement {
    try insert(into: M.self, values: [values])
  }

  static func insert<M: DuetModel>(
    into Model: M.Type,
    values columnValues: [[M.ColumnName: Postgres.Data]]
  ) throws -> PreparedStatement {
    let values = columnValues.map { $0.mapKeys { M.columnName($0) } }
    guard let firstRecord = values.first else {
      throw DbError.emptyBulkInsertInput
    }

    guard values.allSatisfy({ $0.keys.sorted() == firstRecord.keys.sorted() }) else {
      throw DbError.nonUniformBulkInsertInput
    }

    let columns = firstRecord.keys.sorted()
    var placeholderGroups: [String] = []
    var bindings: [Postgres.Data] = []

    for record in values {
      var placeholders: [String] = []
      for key in record.keys.sorted() {
        bindings.append(record[key]!)
        placeholders.append("$\(bindings.count)")
      }
      placeholderGroups.append("(\(placeholders.list))")
    }

    let query = """
    INSERT INTO "\(M.tableName)"
    (\(columns.quotedList))
    VALUES
    \(placeholderGroups.list);
    """

    return PreparedStatement(query: query, bindings: bindings)
  }

  static func select<M: DuetModel>(
    _ columns: Postgres.Columns,
    from Model: M.Type,
    where constraints: [WhereConstraint<M>] = [],
    orderBy order: Order<M>? = nil,
    limit: Int? = nil
  ) -> PreparedStatement {
    var bindings: [Postgres.Data] = []
    let WHERE = whereClause(constraints, bindings: &bindings)
    let ORDER_BY = Order<M>.sql(order)
    let LIMIT = limit.sql()
    let query = """
    SELECT \(columns.sql) FROM "\(M.tableName)"\(WHERE)\(ORDER_BY)\(LIMIT);
    """
    return PreparedStatement(query: query, bindings: bindings)
  }

  @discardableResult
  static func execute(
    _ statement: PreparedStatement,
    on db: SQLDatabase
  ) async throws -> [SQLRow] {
    // e.g. SELECT statements with no WHERE clause have
    // no bindings, and so can't be sent as a pg prepared statement
    if statement.bindings.isEmpty {
      logSql(statement.query)
      return try await db.raw("\(raw: statement.query)").all()
    }

    let types = statement.bindings.map(\.typeName).list
    let params = statement.bindings.map(\.param).list
    let key = [statement.query, types].joined()
    let name: String

    if let previouslyInsertedName = await prepared.get(key) {
      name = previouslyInsertedName
    } else {
      let id = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
      name = "plan_\(id)"
      let insertPrepareSql = """
      PREPARE \(name)(\(types)) AS
      \(statement.query)
      """
      await prepared.set(name, forKey: key)
      _ = try await db.raw("\(raw: insertPrepareSql)").all().get()
    }

    logSql(unPrepare(statement: statement))
    return try await db.raw("\(raw: "EXECUTE \(name)(\(params))")").all()
  }

  private static func whereClause<M: DuetModel>(
    _ constraints: [WhereConstraint<M>]?,
    bindings: inout [Postgres.Data],
    separatedBy: String = "\n"
  ) -> String {
    guard let constraints = constraints, !constraints.isEmpty else { return "" }
    var parts: [String] = []
    for (index, constraint) in constraints.enumerated() {
      let prefix = index == 0 ? "WHERE" : "AND"
      parts.append("\(prefix) \(constraint.sql(boundTo: &bindings))")
    }
    return "\(separatedBy)\(parts.joined(separator: separatedBy))"
  }

  static func resetPreparedStatements() async {
    await prepared.reset()
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

func == <M: DuetModel>(lhs: M.ColumnName, rhs: Postgres.Data) -> SQL.WhereConstraint<M> {
  .init(column: lhs, expression: .equals(rhs))
}

func == <M: DuetModel>(lhs: M.ColumnName, rhs: UUIDStringable) -> SQL.WhereConstraint<M> {
  .init(column: lhs, expression: .equals(.uuid(rhs)))
}

infix operator |=|

// WHERE <column> IN (values...)
func |=| <M: DuetModel>(lhs: M.ColumnName, rhs: [M.IdValue]) -> SQL.WhereConstraint<M> {
  .init(column: lhs, expression: .in(rhs.map { .uuid($0) }))
}

private extension Optional where Wrapped == Int {
  func sql(prefixedBy prefix: String = "\n") -> String {
    guard let limit = self else { return "" }
    return "\(prefix)LIMIT \(limit)"
  }
}

private actor PreparedStatements {
  var statements: [String: String] = [:]

  func get(_ key: String) -> String? {
    statements[key]
  }

  func set(_ value: String, forKey key: String) {
    statements[key] = value
  }

  func reset() {
    statements = [:]
  }
}

private var prepared = PreparedStatements()

private func unPrepare(statement: SQL.PreparedStatement) -> String {
  var sql = statement.query
  for (index, binding) in statement.bindings.reversed().enumerated() {
    sql = sql.replacingOccurrences(of: "$\(statement.bindings.count - index)", with: binding.param)
  }
  return sql
}

private func logSql(_ sql: String) {
  if Vapor.Environment.get("LOG_SQL") != nil {
    print("\n\u{001B}[0;35m\(sql)\u{001B}[0;0m")
  }
}
