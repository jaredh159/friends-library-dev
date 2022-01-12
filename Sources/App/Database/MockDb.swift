final class MockDb {
  typealias Models<M: DuetModel> = ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>
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

  func models<M: DuetModel>(of Model: M.Type) -> Models<M> {
    switch Model.tableName {
      case Token.tableName:
        return \MockDb.tokens as! Models<M>
      case Friend.tableName:
        return \MockDb.friends as! Models<M>
      case FriendQuote.tableName:
        return \MockDb.friendQuotes as! Models<M>
      case FriendResidence.tableName:
        return \MockDb.friendResidences as! Models<M>
      case FriendResidenceDuration.tableName:
        return \MockDb.friendResidenceDurations as! Models<M>
      case Audio.tableName:
        return \MockDb.audios as! Models<M>
      case AudioPart.tableName:
        return \MockDb.audioParts as! Models<M>
      case Isbn.tableName:
        return \MockDb.isbns as! Models<M>
      case Edition.tableName:
        return \MockDb.editions as! Models<M>
      case EditionChapter.tableName:
        return \MockDb.editionChapters as! Models<M>
      case EditionImpression.tableName:
        return \MockDb.editionImpressions as! Models<M>
      case Document.tableName:
        return \MockDb.documents as! Models<M>
      case RelatedDocument.tableName:
        return \MockDb.relatedDocuments as! Models<M>
      case TokenScope.tableName:
        return \MockDb.tokenScopes as! Models<M>
      case Order.tableName:
        return \MockDb.orders as! Models<M>
      case FreeOrderRequest.tableName:
        return \MockDb.freeOrderRequests as! Models<M>
      case Download.tableName:
        return \MockDb.downloads as! Models<M>
      case OrderItem.tableName:
        return \MockDb.orderItems as! Models<M>
      case ArtifactProductionVersion.tableName:
        return \MockDb.artifactProductionVersions as! Models<M>
      case DocumentTag.tableName:
        return \MockDb.documentTags as! Models<M>
      default:
       fatalError("\(Model.tableName) not supported in mockDb")
    }
  }

  func find<M: DuetModel>( _ id: M.IdValue, in keyPath: Models<M>) throws -> M {
    guard let model = self[keyPath: keyPath][id] else {
      throw DbError.notFound
    }
    return model
  }

  func all<M: DuetModel>(_ keyPath: KeyPath<MockDb, [M.IdValue: M]>) -> [M] {
    Array(self[keyPath: keyPath].values)
  }

  func find<M: DuetModel>(where predicate: (M) -> Bool, in keyPath: Models<M>) -> [M] {
    self[keyPath: keyPath].values.filter(predicate)
  }

  func first<M: DuetModel>(where predicate: (M) -> Bool, in keyPath: Models<M>) throws -> M {
    guard let model = self[keyPath: keyPath].values.first(where: predicate) else {
      throw DbError.notFound
    }
    return model
  }

  @discardableResult
  func add<M: DuetModel>(
    _ model: M,
    to keyPath: Models<M>
  ) -> M {
    self[keyPath: keyPath][model.id] = model
    return model
  }
}
