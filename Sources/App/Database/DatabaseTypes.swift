import FluentSQL
import Vapor

protocol Repository {
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
