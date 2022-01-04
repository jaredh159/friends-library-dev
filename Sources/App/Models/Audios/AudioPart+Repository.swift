import FluentSQL
import Vapor

struct AudioPartRepository: LiveRepository {
  typealias Model = AudioPart
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createAudioPart = { try await create($0) }
    client.createAudioParts = { try await create($0) }
    client.getAudioPart = { try await find($0) }
    client.getAudioParts = { try await select() }
    client.updateAudioPart = { try await update($0) }
    client.updateAudioParts = { try await update($0) }
    client.deleteAudioPart = { try await delete($0) }
    client.deleteAllAudioParts = { try await deleteAll() }
  }
}

struct MockAudioPartRepository: MockRepository {
  typealias Model = AudioPart
  var db: MockDb
  var models: ModelsPath { \.audioParts }

  func assign(client: inout DatabaseClient) {
    client.createAudioPart = { try await create($0) }
    client.createAudioParts = { try await create($0) }
    client.getAudioPart = { try await find($0) }
    client.getAudioParts = { try await select() }
    client.updateAudioPart = { try await update($0) }
    client.updateAudioParts = { try await update($0) }
    client.deleteAudioPart = { try await delete($0) }
    client.deleteAllAudioParts = { try await deleteAll() }
  }
}
