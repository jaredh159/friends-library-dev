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
    try await db.forceDelete(Model.self, where: constraints, orderBy: order, limit: limit)
    return models
  }

  func deleteOne() async throws -> Model {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    try await db.forceDelete(Model.self, where: constraints, orderBy: order, limit: limit)
    return try models.firstOrThrowNotFound()
  }

  func all() async throws -> [Model] {
    try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
  }

  func first() async throws -> Model {
    try await all().firstOrThrowNotFound()
  }
}

extension DuetQuery where Model: SoftDeletable {
  func all() async throws -> [Model] {
    try await db.select(
      Model.self,
      where: constraints + ["deleted_at" == .null],
      orderBy: order,
      limit: limit
    )
  }

  func delete() async throws -> [Model] {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    for var model in models {
      model.deletedAt = Current.date()
    }
    try await db.update(models)
    return models
  }

  func deleteOne() async throws -> Model {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    guard var model = models.first else { throw DbError.notFound }
    model.deletedAt = Current.date()
    try await db.update(model)
    return model
  }
}
