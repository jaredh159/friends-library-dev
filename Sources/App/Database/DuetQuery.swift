import Foundation

struct DuetQuery<M: DuetModel> {
  let db: DatabaseClient
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

  func delete(force: Bool = false) async throws -> [M] {
    if force {
      return try await db.forceDelete(M.self, where: constraints, orderBy: order, limit: limit)
    } else {
      return try await db.delete(M.self, where: constraints, orderBy: order, limit: limit)
    }
  }

  func deleteOne(force: Bool = false) async throws -> M {
    let models = try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
    guard !models.isEmpty else { throw DbError.notFound }
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    if force {
      try await db.forceDelete(M.self, where: constraints, orderBy: order, limit: limit)
    } else {
      try await db.delete(M.self, where: constraints, orderBy: order, limit: limit)
    }
    return models.first!
  }

  func all() async throws -> [M] {
    try await db.select(M.self, where: constraints, orderBy: order, limit: limit)
  }

  func first() async throws -> M {
    try await all().firstOrThrowNotFound()
  }
}
