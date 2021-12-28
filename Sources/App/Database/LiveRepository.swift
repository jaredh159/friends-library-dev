import FluentSQL

extension LiveRepository {

  func insert<M: DuetInsertable>(_ model: M) async throws {
    try await insert([model])
  }

  func insert<M: DuetInsertable>(_ models: [M]) async throws {
    let prepared = try SQL.insert(into: M.tableName, values: models.map(\.insertValues))
    _ = try await SQL.execute(prepared, on: db).all()
  }

  func find<M: DuetModel>(_ id: M.IdValue) async throws -> M {
    let prepared = SQL.select(.all, from: M.tableName, where: ("id", .equals, .uuid(id)))
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(M.self) }.firstOrThrowNotFound()
  }

  func select<Model: DuetModel>(
    _ columns: Postgres.Columns,
    from model: Model.Type,
    where: SQL.WhereConstraint? = nil
  ) async throws -> [Model] {
    let prepared = SQL.select(columns, from: model.tableName, where: `where`)
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(model) }
  }

  func updateReturning<Model: DuetModel>(
    _ model: Model.Type,
    set values: [String: Postgres.Data],
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [Model] {
    let prepared = SQL.update(
      model.tableName,
      set: values,
      where: constraint,
      returning: .all
    )
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(model) }
  }
}
