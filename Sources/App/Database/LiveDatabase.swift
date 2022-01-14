import FluentSQL

struct LiveDatabase: SQLQuerying, SQLMutating, DatabaseClient {
  let db: SQLDatabase

  func query<M: DuetModel>(_ Model: M.Type) -> DuetQuery<M> {
    DuetQuery<M>(db: self, constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M] {
    guard !models.isEmpty else { return models }
    let prepared = try SQL.insert(into: M.tableName, values: models.map(\.insertValues))
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M {
    let prepared = SQL.update(
      M.tableName,
      set: model.updateValues,
      where: [("id", .equals, .id(model))],
      returning: .all
    )
    return try await SQL.execute(prepared, on: db).all()
      .compactMap { try $0.decode(M.self) }
      .firstOrThrowNotFound()
  }

  @discardableResult
  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint] = [],
    orderBy: SQL.Order? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let models = try await query(M.self)
      .where(constraints)
      .orderBy(orderBy)
      .limit(limit)
      .all()
    guard !models.isEmpty else { return models }
    // @TODO suuport delete
    let prepared = SQL.delete(from: M.tableName, where: constraints)
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  @discardableResult
  func delete<M: SoftDeletable>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [M] {
    let models = try await select(Model.self, where: [constraint].compactMap { $0 })
    let prepared = SQL.update(
      M.tableName,
      set: ["deleted_at": .currentTimestamp],
      where: [constraint].compactMap { $0 }
    )
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint] = [],
    orderBy: SQL.Order? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let prepared = SQL.select(
      .all,
      from: M.tableName,
      where: constraints,
      orderBy: orderBy,
      limit: limit
    )
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(Model.self) }
  }
}
