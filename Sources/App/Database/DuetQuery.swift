import Foundation

struct DuetQuery<Model: DuetModel> {
  let db: SQLQuerying & SQLMutating
  let constraints: [SQL.WhereConstraint]
  let limit: Int?
  let order: SQL.Order?

  func byId(_ id: UUID) -> DuetQuery<Model> {
    .init(db: db, constraints: constraints + ["id" == .uuid(id)], limit: limit, order: order)
  }

  func byId(_ id: Model.IdValue) -> DuetQuery<Model> {
    .init(db: db, constraints: constraints + ["id" == .uuid(id)], limit: limit, order: order)
  }

  func `where`(_ constraints: SQL.WhereConstraint...) -> DuetQuery<Model> {
    .init(db: db, constraints: self.constraints + constraints, limit: limit, order: order)
  }

  func `where`(_ constraints: [SQL.WhereConstraint]) -> DuetQuery<Model> {
    .init(db: db, constraints: self.constraints + constraints, limit: limit, order: order)
  }

  func limit(_ limit: Int?) -> DuetQuery<Model> {
    .init(db: db, constraints: constraints, limit: limit, order: order)
  }

  func orderBy(_ order: SQL.Order?) -> DuetQuery<Model> {
    .init(
      db: db,
      constraints: constraints,
      limit: limit,
      order: order
    )
  }

  func orderBy(_ column: String, by direction: SQL.OrderDirection) -> DuetQuery<Model> {
    .init(
      db: db,
      constraints: constraints,
      limit: limit,
      order: (column: column, direction: direction)
    )
  }

  func delete() async throws -> [Model] {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    // @TODO implment
    return models
  }

  func deleteOne() async throws -> Model {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    // @TODO implment
    return try models.firstOrThrowNotFound()
  }

  func all() async throws -> [Model] {
    try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
  }

  func first() async throws -> Model {
    try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
      .firstOrThrowNotFound()
  }
}
