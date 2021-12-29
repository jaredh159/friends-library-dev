import FluentSQL
import Vapor

struct ThingRepository {
  var db: SQLDatabase
}

struct MockThingRepository {
  var db: MockDb
}

/// extensions

extension ThingRepository: LiveRepository {
  typealias Model = Thing
  func assign(client: inout DatabaseClient) {
    // client.createThing = { try await create($0) }
  }
}

extension MockThingRepository: MockRepository {
  typealias Model = Thing

  func assign(client: inout DatabaseClient) {
    // client.createThing = { try await create($0) }
  }
}
