import Fluent
import FluentSQL
import Tagged
import Vapor

protocol DbClient {
  func query<Model: DuetModel>(_ Model: Model.Type) -> DuetQuery<Model>

  @discardableResult
  func update<Model: DuetModel>(_ model: Model) async throws -> Model

  @discardableResult
  func create<Model: DuetModel>(_ models: [Model]) async throws -> [Model]
}

extension DbClient {
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

// extensions

struct ThrowingSql: SQLQuerying, SQLMutating {

  func update<M: DuetModel>(_ model: M) async throws -> M {
    throw Abort(.notImplemented, reason: "ThrowingSql.update")
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order?,
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
    orderBy: SQL.Order?,
    limit: Int?
  ) async throws -> [M] {
    throw Abort(.notImplemented, reason: "ThrowingSql.forceDelete")
  }
}

struct ThrowingDbClient: DbClient {
  func query<Model: DuetModel>(_ Model: Model.Type) -> DuetQuery<Model> {
    DuetQuery<Model>(db: ThrowingSql(), constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func update<Model: DuetModel>(_ model: Model) async throws -> Model {
    throw Abort(.notImplemented, reason: "ThrowingDbClient.update")
  }

  @discardableResult
  func create<Model: DuetModel>(_ models: [Model]) async throws -> [Model] {
    throw Abort(.notImplemented, reason: "ThrowingDbClient.create")
  }
}
