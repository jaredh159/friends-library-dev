
import FluentSQL
import Vapor

struct IsbnRepository: LiveRepository {
  typealias Model = Isbn
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createIsbn = { try await create($0) }
    client.createIsbns = { try await create($0) }
    client.getIsbn = { try await find($0) }
    client.getIsbns = { try await select() }
    client.updateIsbn = { try await update($0) }
    client.updateIsbns = { try await update($0) }
    client.deleteIsbn = { try await delete($0) }
    client.deleteAllIsbns = { try await deleteAll() }
  }
}

struct MockIsbnRepository: MockRepository {
  typealias Model = Isbn
  var db: MockDb
  var models: ModelsPath { \.isbns }

  func assign(client: inout DatabaseClient) {
    client.createIsbn = { try await create($0) }
    client.createIsbns = { try await create($0) }
    client.getIsbn = { try await find($0) }
    client.getIsbns = { try await select() }
    client.updateIsbn = { try await update($0) }
    client.updateIsbns = { try await update($0) }
    client.deleteIsbn = { try await delete($0) }
    client.deleteAllIsbns = { try await deleteAll() }
  }
}
