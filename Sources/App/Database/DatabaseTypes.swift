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
  var eventLoop: EventLoop { get }
  init(db: MockDb, eventLoop: EventLoop)
}

extension MockRepository {
  func future<T>(_ value: T) -> Future<T> {
    eventLoop.makeSucceededFuture(value)
  }
}

enum DbError: Error {
  case notFound
  case decodingFailed
  case nonUniformBulkInsertInput
  case emptyBulkInsertInput
}
