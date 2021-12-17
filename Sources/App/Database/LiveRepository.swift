import FluentSQL

extension LiveRepository {

  func insert(into table: String, values: [[String: Postgres.Data]]) throws -> Future<Void> {
    let prepared = try SQL.insert(into: table, values: values)
    return try SQL.execute(prepared, on: db)
      .flatMap { (builder: SQLRawBuilder) in builder.all() }
      .map { (rows: [SQLRow]) in return () }
  }

  func insert(into table: String, values: [String: Postgres.Data]) throws -> Future<Void> {
    let prepared = try SQL.insert(into: table, values: values)
    return try SQL.execute(prepared, on: db)
      .flatMap { (builder: SQLRawBuilder) in builder.all() }
      .map { (rows: [SQLRow]) in return () }
  }

  func select<Model: DuetModel>(
    _ columns: Postgres.Columns,
    from model: Model.Type,
    where: SQL.WhereConstraint
  ) throws -> Future<[Model]> {
    let prepared = SQL.select(columns, from: model.tableName, where: `where`)
    return try SQL.execute(prepared, on: db)
      .flatMap { (builder: SQLRawBuilder) in builder.all() }
      .flatMapThrowing { (rows: [SQLRow]) in
        try rows.compactMap { try $0.decode(model) }
      }
  }

  func updateReturning<Model: DuetModel>(
    _ model: Model.Type,
    set values: [String: Postgres.Data],
    where constraint: SQL.WhereConstraint? = nil
  ) throws -> Future<[Model]> {
    let prepared = SQL.update(
      model.tableName, set: values, where: constraint, returning: .all)
    return try SQL.execute(prepared, on: db)
      .flatMap { (builder: SQLRawBuilder) in builder.all() }
      .flatMapThrowing { (rows: [SQLRow]) in
        try rows.compactMap { try $0.decode(model) }
      }
  }
}
