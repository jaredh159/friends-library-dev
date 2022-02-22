import Vapor

struct ThrowingDatabaseClient: DatabaseClient {
  func entities() async throws -> PreloadedEntities {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.entities")
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint<M>]?,
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.select")
  }

  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint<M>],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.forceDelete")
  }

  func delete<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint<M>],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.delete")
  }

  func query<Model: DuetModel>(_ Model: Model.Type) -> DuetQuery<Model> {
    DuetQuery<Model>(db: self, constraints: [], limit: nil, order: nil)
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
