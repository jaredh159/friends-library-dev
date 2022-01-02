
import FluentSQL
import Vapor

struct EditionImpressionRepository: LiveRepository {
  typealias Model = EditionImpression
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createEditionImpression = { try await create($0) }
    client.createEditionImpressions = { try await create($0) }
    client.getEditionImpression = { try await find($0) }
    client.getEditionImpressions = { try await select() }
    client.updateEditionImpression = { try await update($0) }
    client.updateEditionImpressions = { try await update($0) }
    client.deleteEditionImpression = { try await delete($0) }
    client.deleteAllEditionImpressions = { try await deleteAll() }
  }
}

struct MockEditionImpressionRepository: MockRepository {
  typealias Model = EditionImpression
  var db: MockDb
  var models: ModelsPath { \.editionImpressions }

  func assign(client: inout DatabaseClient) {
    client.createEditionImpression = { try await create($0) }
    client.createEditionImpressions = { try await create($0) }
    client.getEditionImpression = { try await find($0) }
    client.getEditionImpressions = { try await select() }
    client.updateEditionImpression = { try await update($0) }
    client.updateEditionImpressions = { try await update($0) }
    client.deleteEditionImpression = { try await delete($0) }
    client.deleteAllEditionImpressions = { try await deleteAll() }
  }
}
