import DuetSQL

@testable import App

class MockEntityRepository: EntityRepository {
  let db: MockDatabase
  var entities: PreloadedEntities?

  func getEntities() async throws -> PreloadedEntities {
    if let entities = entities {
      return entities
    }

    let store = PreloadedEntitiesStore(
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
      audioParts: db.audioParts,
      isbns: db.isbns
    )

    let loaded = PreloadedEntities(store: store)
    entities = loaded
    return loaded
  }

  init(db: MockDatabase) {
    self.db = db
  }
}

final class MockDatabase: MemoryStore {
  func keyPath<M: Model>(to Model: M.Type) -> Models<M> {
    switch Model.tableName {
      case Token.tableName:
        return \MockDatabase.tokens as! Models<M>
      case Friend.tableName:
        return \MockDatabase.friends as! Models<M>
      case FriendQuote.tableName:
        return \MockDatabase.friendQuotes as! Models<M>
      case FriendResidence.tableName:
        return \MockDatabase.friendResidences as! Models<M>
      case FriendResidenceDuration.tableName:
        return \MockDatabase.friendResidenceDurations as! Models<M>
      case Audio.tableName:
        return \MockDatabase.audios as! Models<M>
      case AudioPart.tableName:
        return \MockDatabase.audioParts as! Models<M>
      case Isbn.tableName:
        return \MockDatabase.isbns as! Models<M>
      case Edition.tableName:
        return \MockDatabase.editions as! Models<M>
      case EditionChapter.tableName:
        return \MockDatabase.editionChapters as! Models<M>
      case EditionImpression.tableName:
        return \MockDatabase.editionImpressions as! Models<M>
      case Document.tableName:
        return \MockDatabase.documents as! Models<M>
      case RelatedDocument.tableName:
        return \MockDatabase.relatedDocuments as! Models<M>
      case TokenScope.tableName:
        return \MockDatabase.tokenScopes as! Models<M>
      case Order.tableName:
        return \MockDatabase.orders as! Models<M>
      case FreeOrderRequest.tableName:
        return \MockDatabase.freeOrderRequests as! Models<M>
      case Download.tableName:
        return \MockDatabase.downloads as! Models<M>
      case OrderItem.tableName:
        return \MockDatabase.orderItems as! Models<M>
      case ArtifactProductionVersion.tableName:
        return \MockDatabase.artifactProductionVersions as! Models<M>
      case DocumentTag.tableName:
        return \MockDatabase.documentTags as! Models<M>
      default:
        fatalError("\(Model.tableName) not supported in mockDb")
    }
  }

  var tokens: [Token.Id: Token] = [:]
  var friends: [Friend.Id: Friend] = [:]
  var friendQuotes: [FriendQuote.Id: FriendQuote] = [:]
  var friendResidences: [FriendResidence.Id: FriendResidence] = [:]
  var friendResidenceDurations: [FriendResidenceDuration.Id: FriendResidenceDuration] = [:]
  var audios: [Audio.Id: Audio] = [:]
  var audioParts: [AudioPart.Id: AudioPart] = [:]
  var isbns: [Isbn.Id: Isbn] = [:]
  var editions: [Edition.Id: Edition] = [:]
  var editionChapters: [EditionChapter.Id: EditionChapter] = [:]
  var editionImpressions: [EditionImpression.Id: EditionImpression] = [:]
  var documents: [Document.Id: Document] = [:]
  var relatedDocuments: [RelatedDocument.Id: RelatedDocument] = [:]
  var tokenScopes: [TokenScope.Id: TokenScope] = [:]
  var orders: [Order.Id: Order] = [:]
  var freeOrderRequests: [FreeOrderRequest.Id: FreeOrderRequest] = [:]
  var downloads: [Download.Id: Download] = [:]
  var orderItems: [OrderItem.Id: OrderItem] = [:]
  var artifactProductionVersions: [ArtifactProductionVersion.Id: ArtifactProductionVersion] = [:]
  var documentTags: [DocumentTag.Id: DocumentTag] = [:]
}

class MockClient: EntityClient {
  let db = MockDatabase()
  let client: MemoryClient<MockDatabase>
  lazy var entityRepo: EntityRepository = MockEntityRepository(db: self.db)

  init() {
    client = MemoryClient(store: db)
  }

  func entities() async throws -> PreloadedEntities {
    try await entityRepo.getEntities()
  }

  func query<M: Model>(_ Model: M.Type) -> DuetQuery<M> {
    .init(db: self, constraints: [], limit: nil, order: nil)
  }

  func select<M: Model>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>]?,
    orderBy order: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    if M.isPreloaded {
      return try await entityRepo.getEntities()
        .select(Model.self, where: constraints, orderBy: order, limit: limit)
    }
    return try await client.select(Model.self, where: constraints, orderBy: order, limit: limit)
  }

  func create<M: Model>(_ models: [M]) async throws -> [M] {
    let inserted = try await client.create(models)
    if M.isPreloaded { await entityRepo.flush() }
    return inserted
  }

  func delete<M>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>],
    orderBy order: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] where M: Model {
    let deleted = try await client.delete(
      Model.self,
      where: constraints,
      orderBy: order,
      limit: limit
    )
    if M.isPreloaded { await entityRepo.flush() }
    return deleted
  }

  func forceDelete<M: Model>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>],
    orderBy order: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    let deleted = try await client.forceDelete(
      Model.self,
      where: constraints,
      orderBy: order,
      limit: limit
    )
    if M.isPreloaded { await entityRepo.flush() }
    return deleted
  }

  func update<M: Model>(_ model: M) async throws -> M {
    let updated = try await client.update(model)
    if M.isPreloaded { await entityRepo.flush() }
    return updated
  }
}
