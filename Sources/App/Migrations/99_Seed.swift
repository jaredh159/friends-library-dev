import Fluent
import Vapor

struct Seed: Migration {

  func prepare(on database: Database) -> Future<Void> {
    return database.eventLoop.makeSucceededVoidFuture()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.eventLoop.makeSucceededVoidFuture()
  }
}
