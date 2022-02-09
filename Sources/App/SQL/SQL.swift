import FluentSQL
import Foundation

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
    let column: M.ColumnName
    let `operator`: Postgres.WhereOperator
    let value: Postgres.Data

    static func isNull(_ column: M.ColumnName) -> WhereConstraint<M> {
      column == .null
    }

    func sql(boundTo binding: Int) -> String {
      "\"\(M.columnName(column))\" \(self.operator.sql) $\(binding)"
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
    var binding = 1
    var bindings: [Postgres.Data] = []
    let WHERE = whereClause(constraints, currentBinding: &binding, bindings: &bindings)
    let ORDER_BY = Order<M>.sql(orderBy)
    let LIMIT = limit.sql()
    let query = #"DELETE FROM "\#(Model.tableName)"\#(WHERE)\#(ORDER_BY)\#(LIMIT);"#
    return PreparedStatement(query: query, bindings: bindings)
  }

  static func softDelete<M: SoftDeletable>(
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
    var currentBinding = 1

    for (column, value) in values.filter({ key, _ in key != "created_at" && key != "id" }) {
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
    var binding = 1
    var bindings: [Postgres.Data] = []
    let WHERE = whereClause(constraints, currentBinding: &binding, bindings: &bindings)
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

    Current.logger.info("Executing SQL:\n\n\(statement.query)\n")

    return try await db.raw("\(raw: "EXECUTE \(name)(\(params))")").all()
  }

  private static func whereClause<M: DuetModel>(
    _ constraints: [WhereConstraint<M>]?,
    currentBinding binding: inout Int,
    bindings: inout [Postgres.Data],
    separatedBy: String = "\n"
  ) -> String {
    guard let constraints = constraints, !constraints.isEmpty else { return "" }
    var parts: [String] = []
    for (index, constraint) in constraints.enumerated() {
      let prefix = index == 0 ? "WHERE" : "AND"
      bindings.append(constraint.value)
      parts.append("\(prefix) \(constraint.sql(boundTo: binding))")
      binding += 1
    }
    return "\(separatedBy)\(parts.joined(separator: separatedBy))"
  }

  static func resetPreparedStatements() async {
    await prepared.reset()
  }
}

extension Sequence where Element == String {
  fileprivate var list: String {
    joined(separator: ", ")
  }

  fileprivate var quotedList: String {
    "\"\(joined(separator: "\", \""))\""
  }
}

func == <M: DuetModel>(lhs: M.ColumnName, rhs: Postgres.Data) -> SQL.WhereConstraint<M> {
  .init(column: lhs, operator: .equals, value: rhs)
}

func == <M: DuetModel>(lhs: M.ColumnName, rhs: UUIDStringable) -> SQL.WhereConstraint<M> {
  .init(column: lhs, operator: .equals, value: .uuid(rhs))
}

extension Optional where Wrapped == Int {
  fileprivate func sql(prefixedBy prefix: String = "\n") -> String {
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
