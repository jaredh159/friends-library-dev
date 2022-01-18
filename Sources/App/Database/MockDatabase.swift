import Foundation
import Vapor

final class MockDatabase: DatabaseClient, InMemoryDatabase, HasEntityRepository {
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

  lazy var entityRepo: EntityRepository = MockEntityRepository(db: self)

  func query<M: DuetModel>(_ Model: M.Type) -> DuetQuery<M> {
    DuetQuery<M>(db: self, constraints: [], limit: nil, order: nil)
  }

  func create<M: DuetModel>(_ insert: [M]) async throws -> [M] {
    for model in insert {
      self[keyPath: modelsKeyPath(of: M.self)][model.id] = model
    }
    if M.isPreloaded { await entityRepo.flush() }
    return insert
  }

  func update<M: DuetModel>(_ model: M) async throws -> M {
    self[keyPath: modelsKeyPath(of: M.self)][model.id] = model
    if M.isPreloaded { await entityRepo.flush() }
    return model
  }

  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>],
    orderBy: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    let keyPath = modelsKeyPath(of: M.self)
    let selected = try await select(Model, where: constraints, orderBy: orderBy, limit: limit)
    for model in selected {
      self[keyPath: keyPath][model.id] = nil
    }
    if M.isPreloaded { await entityRepo.flush() }
    return selected
  }

  func models<M: DuetModel>(of Model: M.Type) async throws -> [M.IdValue: M] {
    self[keyPath: modelsKeyPath(of: M.self)]
  }

  func modelsKeyPath<M: DuetModel>(of Model: M.Type) -> Models<M> {
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
}
