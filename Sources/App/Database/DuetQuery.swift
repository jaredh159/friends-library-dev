import Foundation

struct DuetQuery<M: DuetModel> {
  let db: SQLQuerying & SQLMutating
  let constraints: [SQL.WhereConstraint<M>]
  let limit: Int?
  let order: SQL.Order<M>?

  func byId(_ id: UUIDStringable) throws -> DuetQuery<M> {
    try .init(
      db: db,
      constraints: constraints + [M.column("id") == .uuid(id)],
      limit: limit,
      order: order
    )
  }

  func `where`(_ constraints: SQL.WhereConstraint<M>...) -> DuetQuery<M> {
    .init(db: db, constraints: self.constraints + constraints, limit: limit, order: order)
  }

  func `where`(_ constraints: [SQL.WhereConstraint<M>]) -> DuetQuery<M> {
    .init(db: db, constraints: self.constraints + constraints, limit: limit, order: order)
  }

  func limit(_ limit: Int?) -> DuetQuery<M> {
    .init(db: db, constraints: constraints, limit: limit, order: order)
  }

  func orderBy(_ order: SQL.Order<M>?) -> DuetQuery<M> {
    .init(
      db: db,
      constraints: constraints,
      limit: limit,
      order: order
    )
  }

  func orderBy(_ column: M.ColumnName, _ direction: SQL.OrderDirection) -> DuetQuery<M> {
    .init(
      db: db,
      constraints: constraints,
      limit: limit,
      order: .init(column: column, direction: direction)
    )
  }

  func delete() async throws -> [M] {
    let models = try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
    try await db.forceDelete(M.self, where: constraints, orderBy: order, limit: limit)
    return models
  }

  func deleteOne() async throws -> M {
    let models = try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    try await db.forceDelete(M.self, where: constraints, orderBy: order, limit: limit)
    return try models.firstOrThrowNotFound()
  }

  func all() async throws -> [M] {
    try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
  }

  func first() async throws -> M {
    try await all().firstOrThrowNotFound()
  }
}

extension DuetQuery where M: SoftDeletable {
  func all() async throws -> [M] {
    try await db.select(
      M.self,
      where: constraints + [M.column("deleted_at") == .null],
      orderBy: order,
      limit: limit
    )
  }

  func delete() async throws -> [M] {
    let models = try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
    for var model in models {
      model.deletedAt = Current.date()
    }
    try await db.update(models)
    return models
  }

  func deleteOne() async throws -> M {
    let models = try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    guard var model = models.first else { throw DbError.notFound }
    model.deletedAt = Current.date()
    try await db.update(model)
    return model
  }
}
