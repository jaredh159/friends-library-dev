import DuetSQL
import Vapor

struct ThrowingDatabaseClient: EntityClient {
  func entities() async throws -> PreloadedEntities {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.entities")
  }

  func select<M: DuetSQL.Model>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint<M>]?,
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.select")
  }

  func forceDelete<M: DuetSQL.Model>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint<M>],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.forceDelete")
  }

  func delete<M: DuetSQL.Model>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint<M>],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.delete")
  }

  func query<M: DuetSQL.Model>(_ Model: M.Type) -> DuetQuery<M> {
    DuetQuery<M>(db: self, constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func update<M: DuetSQL.Model>(_ model: M) async throws -> M {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.update")
  }

  @discardableResult
  func create<M: DuetSQL.Model>(_ models: [M]) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingDatabaseClient.create")
  }
}
