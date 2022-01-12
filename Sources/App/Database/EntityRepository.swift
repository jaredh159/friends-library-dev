import FluentSQL
import Vapor

private var liveEntities: PreloadedEntities?
private var mockEntities: PreloadedEntities?

struct EntityRepository {
  let db: SQLDatabase

  func getEntities() async throws -> PreloadedEntities {
    if let entities = liveEntities {
      return entities
    }

    async let friends = findAll(Friend.self)
    async let friendQuotes = findAll(FriendQuote.self)
    async let friendResidences = findAll(FriendResidence.self)
    async let friendResidenceDurations = findAll(FriendResidenceDuration.self)
    async let documents = findAll(Document.self)
    async let documentTags = findAll(DocumentTag.self)
    async let relatedDocuments = findAll(RelatedDocument.self)
    async let editions = findAll(Edition.self)
    async let editionImpressions = findAll(EditionImpression.self)
    async let editionChapters = findAll(EditionChapter.self)
    async let audios = findAll(Audio.self)
    async let audioParts = findAll(AudioPart.self)

    let entities = PreloadedEntities(
      friends: try await friends,
      friendQuotes: try await friendQuotes,
      friendResidences: try await friendResidences,
      friendResidenceDurations: try await friendResidenceDurations,
      documents: try await documents,
      documentTags: try await documentTags,
      relatedDocuments: try await relatedDocuments,
      editions: try await editions,
      editionImpressions: try await editionImpressions,
      editionChapters: try await editionChapters,
      audios: try await audios,
      audioParts: try await audioParts
    )

    liveEntities = entities
    return entities
  }

  private func findAll<M: DuetModel>(_ Model: M.Type) async throws -> [M] {
    let prepared = SQL.select(.all, from: M.tableName)
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(Model.self) }
  }

  func flush() {
    liveEntities = nil
  }

  func assign(client: inout DatabaseClient) {
    client.entities = { try await getEntities() }
    client.flushEntities = { flush() }
  }

  init(db: SQLDatabase) {
    self.db = db
  }
}

struct MockEntityRepository {
  let db: MockDb

  func getEntities() async throws -> PreloadedEntities {
    if let entities = mockEntities {
      return entities
    }

    let entities = PreloadedEntities(
      friends: db.friends,
      friendQuotes: db.friendQuotes,
      friendResidences: db.friendResidences,
      friendResidenceDurations: db.friendResidenceDurations,
      documents: db.documents,
      documentTags: db.documentTags,
      relatedDocuments: db.relatedDocuments,
      editions: db.editions,
      editionImpressions: db.editionImpressions,
      editionChapters: db.editionChapters,
      audios: db.audios,
      audioParts: db.audioParts
    )

    mockEntities = entities
    return entities
  }

  func flush() {
    mockEntities = nil
  }

  func assign(client: inout DatabaseClient) {
    client.entities = { try await getEntities() }
    client.flushEntities = { flush() }
  }

  init(db: MockDb) {
    self.db = db
  }
}

extension Children {
  mutating func push(_ child: C) {
    switch self {
      case .notLoaded:
        self = .loaded([child])
      case .loaded(let children):
        self = .loaded(children + [child])
    }
  }
}
