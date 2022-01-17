import Fluent
import FluentSQL
import Tagged
import Vapor

protocol SQLQuerying {
  func select<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint]?,
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M]
}

protocol SQLMutating {
  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M]

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M

  @discardableResult
  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M]
}

protocol DatabaseClient: SQLQuerying, SQLMutating {
  func query<Model: DuetModel>(_ Model: Model.Type) -> DuetQuery<Model>

  @discardableResult
  func update<Model: DuetModel>(_ model: Model) async throws -> Model

  @discardableResult
  func create<Model: DuetModel>(_ models: [Model]) async throws -> [Model]
}

extension DatabaseClient {
  func find<M: DuetModel>(_ Model: M.Type, byId id: UUID) async throws -> M {
    try await query(M.self).byId(id).first()
  }

  func find<M: DuetModel>(_ Model: M.Type, byId id: M.IdValue) async throws -> M {
    try await query(M.self).byId(id).first()
  }

  @discardableResult
  func create<M: DuetModel>(_ model: M) async throws -> M {
    let models = try await create([model])
    return models.first ?? model
  }

  @discardableResult
  func delete<M: DuetModel>(_ Model: M.Type, byId id: UUID) async throws -> M {
    try await query(M.self).where("id" == id).deleteOne()
  }

  @discardableResult
  func delete<M: DuetModel>(_ Model: M.Type, byId id: M.IdValue) async throws -> M {
    try await query(M.self).where("id" == id).deleteOne()
  }
}

extension SQLMutating {
  @discardableResult
  func update<Model: DuetModel>(_ models: [Model]) async throws -> [Model] {
    try await withThrowingTaskGroup(of: Model.self) { group in
      for model in models {
        group.addTask { try await update(model) }
      }
      var updated: [Model] = []
      for try await updatedModel in group {
        updated.append(updatedModel)
      }
      return updated
    }
  }
}

enum DbError: Error {
  case notFound
  case decodingFailed
  case nonUniformBulkInsertInput
  case emptyBulkInsertInput
  case tooManyResultsForDeleteOne
}
