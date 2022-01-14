import FluentSQL
import Vapor

protocol SQLQuerying {
  func select<M: DuetModel>(
    _ Model: M.Type,
    where: [SQL.WhereConstraint],
    orderBy: SQL.Order?,
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
    orderBy: SQL.Order?,
    limit: Int?
  ) async throws -> [M]
}

enum DbError: Error {
  case notFound
  case decodingFailed
  case nonUniformBulkInsertInput
  case emptyBulkInsertInput
  case tooManyResultsForDeleteOne
}
