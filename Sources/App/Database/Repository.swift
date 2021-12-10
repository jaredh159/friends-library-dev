import FluentSQL
import Vapor

final class MockDb {
  var tokens: [Token.Id: Token] = [:]
  var tokenScopes: [TokenScope.Id: TokenScope] = [:]

  func first<M: AppModel>(
    where predicate: (M) -> Bool,
    in keyPath: ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>
  ) throws -> M {
    guard let model = self[keyPath: keyPath].values.first(where: predicate) else {
      throw Abort(.notFound)
    }
    return model
  }

  func add<M: AppModel>(_ model: M, to keyPath: ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>) {
    self[keyPath: keyPath][model.id] = model
  }
}

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
}
