import FluentSQL
import Vapor

protocol Repository {
  associatedtype Model: DuetModel
  func assign(client: inout DatabaseClient)
}

protocol LiveRepository: Repository {
  var db: SQLDatabase { get set }
  init(db: SQLDatabase)
}

protocol MockRepository: Repository {
  typealias ModelsPath = ReferenceWritableKeyPath<MockDb, [Model.IdValue: Model]>
  var db: MockDb { get }
  var models: ModelsPath { get }
  init(db: MockDb)
}

enum DbError: Error {
  case notFound
  case decodingFailed
  case nonUniformBulkInsertInput
  case emptyBulkInsertInput
}
