import FluentSQL
import Vapor

protocol Repository {
  associatedtype Model: DuetInsertable
  func assign(client: inout DatabaseClient)
}

protocol LiveRepository: Repository {
  var db: SQLDatabase { get set }
  init(db: SQLDatabase)
}

protocol MockRepository: Repository {
  var db: MockDb { get }
  init(db: MockDb)
}

enum DbError: Error {
  case notFound
  case decodingFailed
  case nonUniformBulkInsertInput
  case emptyBulkInsertInput
}
