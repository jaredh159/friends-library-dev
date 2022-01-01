
import FluentSQL
import Vapor

struct EditionRepository: LiveRepository {
  typealias Model = Edition
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createEdition = { try await create($0) }
    client.createEditions = { try await create($0) }
    client.getEdition = { try await find($0) }
    client.getEditions = { try await select() }
    client.updateEdition = { try await update($0) }
    client.updateEditions = { try await update($0) }
    client.deleteEdition = { try await delete($0) }
    client.deleteAllEditions = { try await deleteAll() }
  }
}

struct MockEditionRepository: MockRepository {
  typealias Model = Edition
  var db: MockDb
  var models: ModelsPath { \.editions }

  func assign(client: inout DatabaseClient) {
    client.createEdition = { try await create($0) }
    client.createEditions = { try await create($0) }
    client.getEdition = { try await find($0) }
    client.getEditions = { try await select() }
    client.updateEdition = { try await update($0) }
    client.updateEditions = { try await update($0) }
    client.deleteEdition = { try await delete($0) }
    client.deleteAllEditions = { try await deleteAll() }
  }
}
