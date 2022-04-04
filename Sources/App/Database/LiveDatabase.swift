import DuetSQL
import FluentSQL

struct LiveDatabase: EntityClient {
  let db: SQLDatabase
  let entityRepo: EntityRepository
  let client: DuetSQL.Client

  init(db: SQLDatabase) {
    self.db = db
    entityRepo = LiveEntityRepository(db: db)
    client = LiveClient(db: db)
  }

  func entities() async throws -> PreloadedEntities {
    try await entityRepo.getEntities()
  }

  func query<M: DuetSQL.Model>(_ Model: M.Type) -> DuetQuery<M> {
    .init(db: self, constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func create<M: DuetSQL.Model>(_ models: [M]) async throws -> [M] {
    let models = try await client.create(models)
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  @discardableResult
  func update<M: DuetSQL.Model>(_ model: M) async throws -> M {
    let models = try await client.update(model)
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  @discardableResult
  func forceDelete<M: DuetSQL.Model>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>] = [],
    orderBy: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let models = try await client.forceDelete(
      Model,
      where: constraints,
      orderBy: orderBy,
      limit: limit
    )
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  @discardableResult
  func delete<M: DuetSQL.Model>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>],
    orderBy order: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let models = try await client.delete(Model, where: constraints, orderBy: order, limit: limit)
    if M.isPreloaded { await entityRepo.flush() }
    return models
  }

  func select<M: DuetSQL.Model>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>]? = nil,
    orderBy: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let selectConstraints = try selectConstraints(constraints)
    if M.isPreloaded {
      return try await entityRepo.getEntities()
        .select(M.self, where: selectConstraints, orderBy: orderBy, limit: limit)
    }
    return try await client.select(Model, where: constraints, orderBy: orderBy, limit: limit)
  }
}
