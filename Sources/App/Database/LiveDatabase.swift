import FluentSQL

struct LiveDatabase: SQLQuerying, SQLMutating, DatabaseClient {
  let db: SQLDatabase
  let entityRepo: EntityRepository

  init(db: SQLDatabase) {
    self.db = db
    entityRepo = LiveEntityRepository(db: db)
  }

  func query<M: DuetModel>(_ Model: M.Type) -> DuetQuery<M> {
    DuetQuery<M>(db: self, constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M] {
    guard !models.isEmpty else { return models }
    let prepared = try SQL.insert(into: M.self, values: models.map(\.insertValues))
    try await SQL.execute(prepared, on: db)
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M {
    let prepared = try SQL.update(
      M.self,
      set: model.insertValues,
      where: [M.column("id") == .id(model)],
      returning: .all
    )
    let models = try await SQL.execute(prepared, on: db)
      .compactMap { try $0.decode(M.self) }
      .firstOrThrowNotFound()
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  @discardableResult
  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>] = [],
    orderBy: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let models = try await query(M.self)
      .where(constraints)
      .orderBy(orderBy)
      .limit(limit)
      .all()
    guard !models.isEmpty else { return models }
    let prepared = SQL.delete(from: M.self, where: constraints)
    try await SQL.execute(prepared, on: db)
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  @discardableResult
  func delete<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>],
    orderBy order: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let models = try await select(Model.self, where: constraints)
    let prepared: SQL.PreparedStatement
    if Model.isSoftDeletable {
      prepared = SQL.softDelete(M.self, where: constraints)
    } else {
      prepared = SQL.delete(from: M.self, where: constraints, orderBy: order, limit: limit)
    }
    try await SQL.execute(prepared, on: db)
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>]? = nil,
    orderBy: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let selectConstraints = !Model.isSoftDeletable
      ? constraints
      : (constraints ?? []) + [try Model.column("deleted_at") == .null]
    if M.isPreloaded {
      return try await entityRepo.getEntities()
        .select(M.self, where: selectConstraints, orderBy: orderBy, limit: limit)
    }
    let prepared = SQL.select(
      .all,
      from: M.self,
      where: selectConstraints ?? [],
      orderBy: orderBy,
      limit: limit
    )
    let rows = try await SQL.execute(prepared, on: db)
    return try rows.compactMap { try $0.decode(Model.self) }
  }
}
