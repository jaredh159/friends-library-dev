
import FluentSQL
import Vapor

struct AudioRepository: LiveRepository {
  typealias Model = Audio
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createAudio = { try await create($0) }
    client.createAudios = { try await create($0) }
    client.getAudio = { try await find($0) }
    client.getAudios = { try await select() }
    client.updateAudio = { try await update($0) }
    client.updateAudios = { try await update($0) }
    client.deleteAudio = { try await delete($0) }
    client.deleteAllAudios = { try await deleteAll() }
  }
}

struct MockAudioRepository: MockRepository {
  typealias Model = Audio
  var db: MockDb
  var models: ModelsPath { \.audios }

  func assign(client: inout DatabaseClient) {
    client.createAudio = { try await create($0) }
    client.createAudios = { try await create($0) }
    client.getAudio = { try await find($0) }
    client.getAudios = { try await select() }
    client.updateAudio = { try await update($0) }
    client.updateAudios = { try await update($0) }
    client.deleteAudio = { try await delete($0) }
    client.deleteAllAudios = { try await deleteAll() }
  }
}
