import Vapor

struct ThrowingSql: SQLQuerying, SQLMutating {

  func update<M: DuetModel>(_ model: M) async throws -> M {
    throw Abort(.notImplemented, reason: "ThrowingSql.update")
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingSql.select")
  }

  func create<M: DuetModel>(_ models: [M]) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingSql.create")
  }

  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingSql.forceDelete")
  }
}

struct ThrowingDatabaseClient: DatabaseClient {
  func select<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.select")
  }

  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.forceDelete")
  }

  func query<Model: DuetModel>(_ Model: Model.Type) -> DuetQuery<Model> {
    DuetQuery<Model>(db: ThrowingSql(), constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func update<Model: DuetModel>(_ model: Model) async throws -> Model {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.update")
  }

  @discardableResult
  func create<Model: DuetModel>(_ models: [Model]) async throws -> [Model] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.create")
  }
}
