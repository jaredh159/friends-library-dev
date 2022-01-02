
import FluentSQL
import Vapor

struct EditionChapterRepository: LiveRepository {
  typealias Model = EditionChapter
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createEditionChapter = { try await create($0) }
    client.createEditionChapters = { try await create($0) }
    client.getEditionChapter = { try await find($0) }
    client.getEditionChapters = { try await select() }
    client.updateEditionChapter = { try await update($0) }
    client.updateEditionChapters = { try await update($0) }
    client.deleteEditionChapter = { try await delete($0) }
    client.deleteAllEditionChapters = { try await deleteAll() }
  }
}

struct MockEditionChapterRepository: MockRepository {
  typealias Model = EditionChapter
  var db: MockDb
  var models: ModelsPath { \.editionChapters }

  func assign(client: inout DatabaseClient) {
    client.createEditionChapter = { try await create($0) }
    client.createEditionChapters = { try await create($0) }
    client.getEditionChapter = { try await find($0) }
    client.getEditionChapters = { try await select() }
    client.updateEditionChapter = { try await update($0) }
    client.updateEditionChapters = { try await update($0) }
    client.deleteEditionChapter = { try await delete($0) }
    client.deleteAllEditionChapters = { try await deleteAll() }
  }
}
