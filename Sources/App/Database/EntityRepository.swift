import DuetSQL
import FluentSQL
import Vapor

protocol EntityRepository: AnyObject {
  var entities: PreloadedEntities? { get set }
  func getEntities() async throws -> PreloadedEntities
  func flush() async
}

extension EntityRepository {
  func flush() async {
    if let entities = entities {
      await entities.flush()
    }
    entities = nil
  }
}

class LiveEntityRepository: EntityRepository {
  let db: SQLDatabase
  var entities: PreloadedEntities?

  func getEntities() async throws -> PreloadedEntities {
    if let entities = entities {
      return entities
    }

    Current.logger.info("Querying all entities and caching...")
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
    async let isbns = findAll(Isbn.self)

    let store = PreloadedEntitiesStore(
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
      audioParts: try await audioParts,
      isbns: try await isbns
    )

    let loaded = PreloadedEntities(store: store)
    entities = loaded
    return loaded
  }

  private func findAll<M: ApiModel>(_ Model: M.Type) async throws -> [M] {
    let prepared = SQL.select(.all, from: M.self, where: [.notSoftDeleted])
    let rows = try await SQL.execute(prepared, on: db)
    return try rows.compactMap { try $0.decode(Model.self) }
  }

  init(db: SQLDatabase) {
    self.db = db
  }
}
