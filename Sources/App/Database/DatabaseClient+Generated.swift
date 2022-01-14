// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    let entitiesRepo = EntityRepository(db: db)
    let repo = GenericRepository(db: db)
    let artifactProductionVersions = Repository<ArtifactProductionVersion>(db: db)
    let audios = Repository<Audio>(db: db)
    let audioParts = Repository<AudioPart>(db: db)
    let documents = Repository<Document>(db: db)
    let documentTags = Repository<DocumentTag>(db: db)
    let relatedDocuments = Repository<RelatedDocument>(db: db)
    let downloads = Repository<Download>(db: db)
    let editions = Repository<Edition>(db: db)
    let editionChapters = Repository<EditionChapter>(db: db)
    let editionImpressions = Repository<EditionImpression>(db: db)
    let friends = Repository<Friend>(db: db)
    let friendQuotes = Repository<FriendQuote>(db: db)
    let friendResidences = Repository<FriendResidence>(db: db)
    let friendResidenceDurations = Repository<FriendResidenceDuration>(db: db)
    let isbns = Repository<Isbn>(db: db)
    let freeOrderRequests = Repository<FreeOrderRequest>(db: db)
    let orders = Repository<Order>(db: db)
    let orderItems = Repository<OrderItem>(db: db)
    let tokens = Repository<Token>(db: db)
    let tokenScopes = Repository<TokenScope>(db: db)
    client.createToken = { try await repo.create($0) }
    client.getToken = { try await repo.find(Token.self, byId: $0) }
    client.getTokens = { try await repo.findAll(Token.self, where: $0) }
    client.createTokenScope = { try await repo.create($0) }
    client.getTokenScopes = { try await repo.findAll(TokenScope.self, where: $0) }
    client.getOrder = { try await repo.find(Order.self, byId: $0) }
    client.getOrders = { try await repo.findAll(Order.self, where: $0) }
    client.updateOrder = { try await repo.update($0) }
    client.updateOrders = { try await repo.update($0) }
    client.createOrder = { try await repo.create($0) }
    client.createOrders = { try await repo.create($0) }
    client.deleteOrder = { try await repo.delete(Order.self, byId: $0) }
    client.deleteAllOrders = { try await repo.delete(Order.self) }
    client.createOrderItem = { try await repo.create($0) }
    client.createOrderItems = { try await repo.create($0) }
    client.getOrderItem = { try await repo.find(OrderItem.self, byId: $0) }
    client.getOrderItems = { try await repo.findAll(OrderItem.self, where: $0) }
    client.updateOrderItem = { try await repo.update($0) }
    client.updateOrderItems = { try await repo.update($0) }
    client.deleteOrderItem = { try await repo.delete(OrderItem.self, byId: $0) }
    client.createFreeOrderRequest = { try await repo.create($0) }
    client.getFreeOrderRequest = { try await repo.find(FreeOrderRequest.self, byId: $0) }
    client.createDownload = { try await repo.create($0) }
    client.createDownloads = { try await repo.create($0) }
    client.getDownload = { try await repo.find(Download.self, byId: $0) }
    client.getDownloads = { try await repo.findAll(Download.self, where: $0) }
    client.updateDownload = { try await repo.update($0) }
    client.updateDownloads = { try await repo.update($0) }
    client.deleteDownload = { try await repo.delete(Download.self, byId: $0) }
    client.deleteAllDownloads = { try await repo.delete(Download.self) }
    client.createFriend = { try await repo.create($0) }
    client.createFriends = { try await repo.create($0) }
    client.getFriend = { try await repo.find(Friend.self, byId: $0) }
    client.getFriends = { try await repo.findAll(Friend.self, where: $0) }
    client.updateFriend = { try await repo.update($0) }
    client.updateFriends = { try await repo.update($0) }
    client.deleteFriend = { try await repo.delete(Friend.self, byId: $0) }
    client.deleteAllFriends = { try await repo.delete(Friend.self) }
    client.createFriendQuote = { try await repo.create($0) }
    client.createFriendQuotes = { try await repo.create($0) }
    client.getFriendQuote = { try await repo.find(FriendQuote.self, byId: $0) }
    client.getFriendQuotes = { try await repo.findAll(FriendQuote.self, where: $0) }
    client.updateFriendQuote = { try await repo.update($0) }
    client.updateFriendQuotes = { try await repo.update($0) }
    client.deleteFriendQuote = { try await repo.delete(FriendQuote.self, byId: $0) }
    client.deleteAllFriendQuotes = { try await repo.delete(FriendQuote.self) }
    client.createFriendResidence = { try await repo.create($0) }
    client.createFriendResidences = { try await repo.create($0) }
    client.getFriendResidence = { try await repo.find(FriendResidence.self, byId: $0) }
    client.getFriendResidences = { try await repo.findAll(FriendResidence.self, where: $0) }
    client.updateFriendResidence = { try await repo.update($0) }
    client.updateFriendResidences = { try await repo.update($0) }
    client.deleteFriendResidence = { try await repo.delete(FriendResidence.self, byId: $0) }
    client.deleteAllFriendResidences = { try await repo.delete(FriendResidence.self) }
    client.createFriendResidenceDuration = { try await repo.create($0) }
    client.createFriendResidenceDurations = { try await repo.create($0) }
    client.getFriendResidenceDuration = { try await repo.find(FriendResidenceDuration.self, byId: $0) }
    client.getFriendResidenceDurations = { try await repo.findAll(FriendResidenceDuration.self, where: $0) }
    client.updateFriendResidenceDuration = { try await repo.update($0) }
    client.updateFriendResidenceDurations = { try await repo.update($0) }
    client.deleteFriendResidenceDuration = { try await repo.delete(FriendResidenceDuration.self, byId: $0) }
    client.deleteAllFriendResidenceDurations = { try await repo.delete(FriendResidenceDuration.self) }
    client.createDocument = { try await repo.create($0) }
    client.createDocuments = { try await repo.create($0) }
    client.getDocument = { try await repo.find(Document.self, byId: $0) }
    client.getDocuments = { try await repo.findAll(Document.self, where: $0) }
    client.updateDocument = { try await repo.update($0) }
    client.updateDocuments = { try await repo.update($0) }
    client.deleteDocument = { try await repo.delete(Document.self, byId: $0) }
    client.deleteAllDocuments = { try await repo.delete(Document.self) }
    client.createDocumentTag = { try await repo.create($0) }
    client.getDocumentTags = { try await repo.findAll(DocumentTag.self, where: $0) }
    client.createRelatedDocument = { try await repo.create($0) }
    client.getRelatedDocuments = { try await repo.findAll(RelatedDocument.self, where: $0) }
    client.createEdition = { try await repo.create($0) }
    client.createEditions = { try await repo.create($0) }
    client.getEdition = { try await repo.find(Edition.self, byId: $0) }
    client.getEditions = { try await repo.findAll(Edition.self, where: $0) }
    client.updateEdition = { try await repo.update($0) }
    client.updateEditions = { try await repo.update($0) }
    client.deleteEdition = { try await repo.delete(Edition.self, byId: $0) }
    client.deleteAllEditions = { try await repo.delete(Edition.self) }
    client.createEditionImpression = { try await repo.create($0) }
    client.createEditionImpressions = { try await repo.create($0) }
    client.getEditionImpression = { try await repo.find(EditionImpression.self, byId: $0) }
    client.getEditionImpressions = { try await repo.findAll(EditionImpression.self, where: $0) }
    client.updateEditionImpression = { try await repo.update($0) }
    client.updateEditionImpressions = { try await repo.update($0) }
    client.deleteEditionImpression = { try await repo.delete(EditionImpression.self, byId: $0) }
    client.deleteAllEditionImpressions = { try await repo.delete(EditionImpression.self) }
    client.createEditionChapter = { try await repo.create($0) }
    client.createEditionChapters = { try await repo.create($0) }
    client.getEditionChapter = { try await repo.find(EditionChapter.self, byId: $0) }
    client.getEditionChapters = { try await repo.findAll(EditionChapter.self, where: $0) }
    client.updateEditionChapter = { try await repo.update($0) }
    client.updateEditionChapters = { try await repo.update($0) }
    client.deleteEditionChapter = { try await repo.delete(EditionChapter.self, byId: $0) }
    client.deleteAllEditionChapters = { try await repo.delete(EditionChapter.self) }
    client.createAudio = { try await repo.create($0) }
    client.createAudios = { try await repo.create($0) }
    client.getAudio = { try await repo.find(Audio.self, byId: $0) }
    client.getAudios = { try await repo.findAll(Audio.self, where: $0) }
    client.updateAudio = { try await repo.update($0) }
    client.updateAudios = { try await repo.update($0) }
    client.deleteAudio = { try await repo.delete(Audio.self, byId: $0) }
    client.deleteAllAudios = { try await repo.delete(Audio.self) }
    client.createAudioPart = { try await repo.create($0) }
    client.createAudioParts = { try await repo.create($0) }
    client.getAudioPart = { try await repo.find(AudioPart.self, byId: $0) }
    client.getAudioParts = { try await repo.findAll(AudioPart.self, where: $0) }
    client.updateAudioPart = { try await repo.update($0) }
    client.updateAudioParts = { try await repo.update($0) }
    client.deleteAudioPart = { try await repo.delete(AudioPart.self, byId: $0) }
    client.deleteAllAudioParts = { try await repo.delete(AudioPart.self) }
    client.createIsbn = { try await repo.create($0) }
    client.createIsbns = { try await repo.create($0) }
    client.getIsbn = { try await repo.find(Isbn.self, byId: $0) }
    client.getIsbns = { try await repo.findAll(Isbn.self, where: $0) }
    client.updateIsbn = { try await repo.update($0) }
    client.updateIsbns = { try await repo.update($0) }
    client.deleteIsbn = { try await repo.delete(Isbn.self, byId: $0) }
    client.deleteAllIsbns = { try await repo.delete(Isbn.self) }
    client.createArtifactProductionVersion = { try await repo.create($0) }
    client.getArtifactProductionVersions = { try await repo.findAll(ArtifactProductionVersion.self, where: $0) }
    artifactProductionVersions.assign(client: &client)
    audios.assign(client: &client)
    audioParts.assign(client: &client)
    documents.assign(client: &client)
    documentTags.assign(client: &client)
    relatedDocuments.assign(client: &client)
    downloads.assign(client: &client)
    editions.assign(client: &client)
    editionChapters.assign(client: &client)
    editionImpressions.assign(client: &client)
    friends.assign(client: &client)
    friendQuotes.assign(client: &client)
    friendResidences.assign(client: &client)
    friendResidenceDurations.assign(client: &client)
    isbns.assign(client: &client)
    freeOrderRequests.assign(client: &client)
    orders.assign(client: &client)
    orderItems.assign(client: &client)
    tokens.assign(client: &client)
    tokenScopes.assign(client: &client)
    entitiesRepo.assign(client: &client)
    return client
  }

  static var mock: DatabaseClient {
    let db = MockDb()
    var client: DatabaseClient = .notImplemented
    let entitiesRepo = MockEntityRepository(db: db)
    let repo = MockGenericRepository(db: db)
    let artifactProductionVersions = MockRepository<ArtifactProductionVersion>(db: db, models: \.artifactProductionVersions)
    let audios = MockRepository<Audio>(db: db, models: \.audios)
    let audioParts = MockRepository<AudioPart>(db: db, models: \.audioParts)
    let documents = MockRepository<Document>(db: db, models: \.documents)
    let documentTags = MockRepository<DocumentTag>(db: db, models: \.documentTags)
    let relatedDocuments = MockRepository<RelatedDocument>(db: db, models: \.relatedDocuments)
    let downloads = MockRepository<Download>(db: db, models: \.downloads)
    let editions = MockRepository<Edition>(db: db, models: \.editions)
    let editionChapters = MockRepository<EditionChapter>(db: db, models: \.editionChapters)
    let editionImpressions = MockRepository<EditionImpression>(db: db, models: \.editionImpressions)
    let friends = MockRepository<Friend>(db: db, models: \.friends)
    let friendQuotes = MockRepository<FriendQuote>(db: db, models: \.friendQuotes)
    let friendResidences = MockRepository<FriendResidence>(db: db, models: \.friendResidences)
    let friendResidenceDurations = MockRepository<FriendResidenceDuration>(db: db, models: \.friendResidenceDurations)
    let isbns = MockRepository<Isbn>(db: db, models: \.isbns)
    let freeOrderRequests = MockRepository<FreeOrderRequest>(db: db, models: \.freeOrderRequests)
    let orders = MockRepository<Order>(db: db, models: \.orders)
    let orderItems = MockRepository<OrderItem>(db: db, models: \.orderItems)
    let tokens = MockRepository<Token>(db: db, models: \.tokens)
    let tokenScopes = MockRepository<TokenScope>(db: db, models: \.tokenScopes)
    client.createToken = { try await repo.create($0) }
    client.getToken = { try await repo.find(Token.self, byId: $0) }
    client.getTokens = { try await repo.findAll(Token.self, where: $0) }
    client.createTokenScope = { try await repo.create($0) }
    client.getTokenScopes = { try await repo.findAll(TokenScope.self, where: $0) }
    client.getOrder = { try await repo.find(Order.self, byId: $0) }
    client.getOrders = { try await repo.findAll(Order.self, where: $0) }
    client.updateOrder = { try await repo.update($0) }
    client.updateOrders = { try await repo.update($0) }
    client.createOrder = { try await repo.create($0) }
    client.createOrders = { try await repo.create($0) }
    client.deleteOrder = { try await repo.delete(Order.self, byId: $0) }
    client.deleteAllOrders = { try await repo.delete(Order.self) }
    client.createOrderItem = { try await repo.create($0) }
    client.createOrderItems = { try await repo.create($0) }
    client.getOrderItem = { try await repo.find(OrderItem.self, byId: $0) }
    client.getOrderItems = { try await repo.findAll(OrderItem.self, where: $0) }
    client.updateOrderItem = { try await repo.update($0) }
    client.updateOrderItems = { try await repo.update($0) }
    client.deleteOrderItem = { try await repo.delete(OrderItem.self, byId: $0) }
    client.createFreeOrderRequest = { try await repo.create($0) }
    client.getFreeOrderRequest = { try await repo.find(FreeOrderRequest.self, byId: $0) }
    client.createDownload = { try await repo.create($0) }
    client.createDownloads = { try await repo.create($0) }
    client.getDownload = { try await repo.find(Download.self, byId: $0) }
    client.getDownloads = { try await repo.findAll(Download.self, where: $0) }
    client.updateDownload = { try await repo.update($0) }
    client.updateDownloads = { try await repo.update($0) }
    client.deleteDownload = { try await repo.delete(Download.self, byId: $0) }
    client.deleteAllDownloads = { try await repo.delete(Download.self) }
    client.createFriend = { try await repo.create($0) }
    client.createFriends = { try await repo.create($0) }
    client.getFriend = { try await repo.find(Friend.self, byId: $0) }
    client.getFriends = { try await repo.findAll(Friend.self, where: $0) }
    client.updateFriend = { try await repo.update($0) }
    client.updateFriends = { try await repo.update($0) }
    client.deleteFriend = { try await repo.delete(Friend.self, byId: $0) }
    client.deleteAllFriends = { try await repo.delete(Friend.self) }
    client.createFriendQuote = { try await repo.create($0) }
    client.createFriendQuotes = { try await repo.create($0) }
    client.getFriendQuote = { try await repo.find(FriendQuote.self, byId: $0) }
    client.getFriendQuotes = { try await repo.findAll(FriendQuote.self, where: $0) }
    client.updateFriendQuote = { try await repo.update($0) }
    client.updateFriendQuotes = { try await repo.update($0) }
    client.deleteFriendQuote = { try await repo.delete(FriendQuote.self, byId: $0) }
    client.deleteAllFriendQuotes = { try await repo.delete(FriendQuote.self) }
    client.createFriendResidence = { try await repo.create($0) }
    client.createFriendResidences = { try await repo.create($0) }
    client.getFriendResidence = { try await repo.find(FriendResidence.self, byId: $0) }
    client.getFriendResidences = { try await repo.findAll(FriendResidence.self, where: $0) }
    client.updateFriendResidence = { try await repo.update($0) }
    client.updateFriendResidences = { try await repo.update($0) }
    client.deleteFriendResidence = { try await repo.delete(FriendResidence.self, byId: $0) }
    client.deleteAllFriendResidences = { try await repo.delete(FriendResidence.self) }
    client.createFriendResidenceDuration = { try await repo.create($0) }
    client.createFriendResidenceDurations = { try await repo.create($0) }
    client.getFriendResidenceDuration = { try await repo.find(FriendResidenceDuration.self, byId: $0) }
    client.getFriendResidenceDurations = { try await repo.findAll(FriendResidenceDuration.self, where: $0) }
    client.updateFriendResidenceDuration = { try await repo.update($0) }
    client.updateFriendResidenceDurations = { try await repo.update($0) }
    client.deleteFriendResidenceDuration = { try await repo.delete(FriendResidenceDuration.self, byId: $0) }
    client.deleteAllFriendResidenceDurations = { try await repo.delete(FriendResidenceDuration.self) }
    client.createDocument = { try await repo.create($0) }
    client.createDocuments = { try await repo.create($0) }
    client.getDocument = { try await repo.find(Document.self, byId: $0) }
    client.getDocuments = { try await repo.findAll(Document.self, where: $0) }
    client.updateDocument = { try await repo.update($0) }
    client.updateDocuments = { try await repo.update($0) }
    client.deleteDocument = { try await repo.delete(Document.self, byId: $0) }
    client.deleteAllDocuments = { try await repo.delete(Document.self) }
    client.createDocumentTag = { try await repo.create($0) }
    client.getDocumentTags = { try await repo.findAll(DocumentTag.self, where: $0) }
    client.createRelatedDocument = { try await repo.create($0) }
    client.getRelatedDocuments = { try await repo.findAll(RelatedDocument.self, where: $0) }
    client.createEdition = { try await repo.create($0) }
    client.createEditions = { try await repo.create($0) }
    client.getEdition = { try await repo.find(Edition.self, byId: $0) }
    client.getEditions = { try await repo.findAll(Edition.self, where: $0) }
    client.updateEdition = { try await repo.update($0) }
    client.updateEditions = { try await repo.update($0) }
    client.deleteEdition = { try await repo.delete(Edition.self, byId: $0) }
    client.deleteAllEditions = { try await repo.delete(Edition.self) }
    client.createEditionImpression = { try await repo.create($0) }
    client.createEditionImpressions = { try await repo.create($0) }
    client.getEditionImpression = { try await repo.find(EditionImpression.self, byId: $0) }
    client.getEditionImpressions = { try await repo.findAll(EditionImpression.self, where: $0) }
    client.updateEditionImpression = { try await repo.update($0) }
    client.updateEditionImpressions = { try await repo.update($0) }
    client.deleteEditionImpression = { try await repo.delete(EditionImpression.self, byId: $0) }
    client.deleteAllEditionImpressions = { try await repo.delete(EditionImpression.self) }
    client.createEditionChapter = { try await repo.create($0) }
    client.createEditionChapters = { try await repo.create($0) }
    client.getEditionChapter = { try await repo.find(EditionChapter.self, byId: $0) }
    client.getEditionChapters = { try await repo.findAll(EditionChapter.self, where: $0) }
    client.updateEditionChapter = { try await repo.update($0) }
    client.updateEditionChapters = { try await repo.update($0) }
    client.deleteEditionChapter = { try await repo.delete(EditionChapter.self, byId: $0) }
    client.deleteAllEditionChapters = { try await repo.delete(EditionChapter.self) }
    client.createAudio = { try await repo.create($0) }
    client.createAudios = { try await repo.create($0) }
    client.getAudio = { try await repo.find(Audio.self, byId: $0) }
    client.getAudios = { try await repo.findAll(Audio.self, where: $0) }
    client.updateAudio = { try await repo.update($0) }
    client.updateAudios = { try await repo.update($0) }
    client.deleteAudio = { try await repo.delete(Audio.self, byId: $0) }
    client.deleteAllAudios = { try await repo.delete(Audio.self) }
    client.createAudioPart = { try await repo.create($0) }
    client.createAudioParts = { try await repo.create($0) }
    client.getAudioPart = { try await repo.find(AudioPart.self, byId: $0) }
    client.getAudioParts = { try await repo.findAll(AudioPart.self, where: $0) }
    client.updateAudioPart = { try await repo.update($0) }
    client.updateAudioParts = { try await repo.update($0) }
    client.deleteAudioPart = { try await repo.delete(AudioPart.self, byId: $0) }
    client.deleteAllAudioParts = { try await repo.delete(AudioPart.self) }
    client.createIsbn = { try await repo.create($0) }
    client.createIsbns = { try await repo.create($0) }
    client.getIsbn = { try await repo.find(Isbn.self, byId: $0) }
    client.getIsbns = { try await repo.findAll(Isbn.self, where: $0) }
    client.updateIsbn = { try await repo.update($0) }
    client.updateIsbns = { try await repo.update($0) }
    client.deleteIsbn = { try await repo.delete(Isbn.self, byId: $0) }
    client.deleteAllIsbns = { try await repo.delete(Isbn.self) }
    client.createArtifactProductionVersion = { try await repo.create($0) }
    client.getArtifactProductionVersions = { try await repo.findAll(ArtifactProductionVersion.self, where: $0) }
    artifactProductionVersions.assign(client: &client)
    audios.assign(client: &client)
    audioParts.assign(client: &client)
    documents.assign(client: &client)
    documentTags.assign(client: &client)
    relatedDocuments.assign(client: &client)
    downloads.assign(client: &client)
    editions.assign(client: &client)
    editionChapters.assign(client: &client)
    editionImpressions.assign(client: &client)
    friends.assign(client: &client)
    friendQuotes.assign(client: &client)
    friendResidences.assign(client: &client)
    friendResidenceDurations.assign(client: &client)
    isbns.assign(client: &client)
    freeOrderRequests.assign(client: &client)
    orders.assign(client: &client)
    orderItems.assign(client: &client)
    tokens.assign(client: &client)
    tokenScopes.assign(client: &client)
    entitiesRepo.assign(client: &client)
    return client
  }

  static let notImplemented = DatabaseClient(
    entities: {
      throw Abort(.notImplemented, reason: "db.entities")
    },
    flushEntities: {
      throw Abort(.notImplemented, reason: "db.flushEntities")
    },
    createToken: { _ in
      throw Abort(.notImplemented, reason: "db.createToken")
    },
    getToken: { _ in
      throw Abort(.notImplemented, reason: "db.getToken")
    },
    getTokens: { _ in
      throw Abort(.notImplemented, reason: "db.getTokens")
    },
    createTokenScope: { _ in
      throw Abort(.notImplemented, reason: "db.createTokenScope")
    },
    getTokenScopes: { _ in
      throw Abort(.notImplemented, reason: "db.getTokenScopes")
    },
    getOrder: { _ in
      throw Abort(.notImplemented, reason: "db.getOrder")
    },
    getOrders: { _ in
      throw Abort(.notImplemented, reason: "db.getOrders")
    },
    updateOrder: { _ in
      throw Abort(.notImplemented, reason: "db.updateOrder")
    },
    updateOrders: { _ in
      throw Abort(.notImplemented, reason: "db.updateOrders")
    },
    createOrder: { _ in
      throw Abort(.notImplemented, reason: "db.createOrder")
    },
    createOrders: { _ in
      throw Abort(.notImplemented, reason: "db.createOrders")
    },
    deleteOrder: { _ in
      throw Abort(.notImplemented, reason: "db.deleteOrder")
    },
    deleteAllOrders: {
      throw Abort(.notImplemented, reason: "db.deleteAllOrders")
    },
    createOrderItem: { _ in
      throw Abort(.notImplemented, reason: "db.createOrderItem")
    },
    createOrderItems: { _ in
      throw Abort(.notImplemented, reason: "db.createOrderItems")
    },
    getOrderItem: { _ in
      throw Abort(.notImplemented, reason: "db.getOrderItem")
    },
    getOrderItems: { _ in
      throw Abort(.notImplemented, reason: "db.getOrderItems")
    },
    updateOrderItem: { _ in
      throw Abort(.notImplemented, reason: "db.updateOrderItem")
    },
    updateOrderItems: { _ in
      throw Abort(.notImplemented, reason: "db.updateOrderItems")
    },
    deleteOrderItem: { _ in
      throw Abort(.notImplemented, reason: "db.deleteOrderItem")
    },
    createFreeOrderRequest: { _ in
      throw Abort(.notImplemented, reason: "db.createFreeOrderRequest")
    },
    getFreeOrderRequest: { _ in
      throw Abort(.notImplemented, reason: "db.getFreeOrderRequest")
    },
    createDownload: { _ in
      throw Abort(.notImplemented, reason: "db.createDownload")
    },
    createDownloads: { _ in
      throw Abort(.notImplemented, reason: "db.createDownloads")
    },
    getDownload: { _ in
      throw Abort(.notImplemented, reason: "db.getDownload")
    },
    getDownloads: { _ in
      throw Abort(.notImplemented, reason: "db.getDownloads")
    },
    updateDownload: { _ in
      throw Abort(.notImplemented, reason: "db.updateDownload")
    },
    updateDownloads: { _ in
      throw Abort(.notImplemented, reason: "db.updateDownloads")
    },
    deleteDownload: { _ in
      throw Abort(.notImplemented, reason: "db.deleteDownload")
    },
    deleteAllDownloads: {
      throw Abort(.notImplemented, reason: "db.deleteAllDownloads")
    },
    createFriend: { _ in
      throw Abort(.notImplemented, reason: "db.createFriend")
    },
    createFriends: { _ in
      throw Abort(.notImplemented, reason: "db.createFriends")
    },
    getFriend: { _ in
      throw Abort(.notImplemented, reason: "db.getFriend")
    },
    getFriends: { _ in
      throw Abort(.notImplemented, reason: "db.getFriends")
    },
    updateFriend: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriend")
    },
    updateFriends: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriends")
    },
    deleteFriend: { _ in
      throw Abort(.notImplemented, reason: "db.deleteFriend")
    },
    deleteAllFriends: {
      throw Abort(.notImplemented, reason: "db.deleteAllFriends")
    },
    createFriendQuote: { _ in
      throw Abort(.notImplemented, reason: "db.createFriendQuote")
    },
    createFriendQuotes: { _ in
      throw Abort(.notImplemented, reason: "db.createFriendQuotes")
    },
    getFriendQuote: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendQuote")
    },
    getFriendQuotes: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendQuotes")
    },
    updateFriendQuote: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriendQuote")
    },
    updateFriendQuotes: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriendQuotes")
    },
    deleteFriendQuote: { _ in
      throw Abort(.notImplemented, reason: "db.deleteFriendQuote")
    },
    deleteAllFriendQuotes: {
      throw Abort(.notImplemented, reason: "db.deleteAllFriendQuotes")
    },
    createFriendResidence: { _ in
      throw Abort(.notImplemented, reason: "db.createFriendResidence")
    },
    createFriendResidences: { _ in
      throw Abort(.notImplemented, reason: "db.createFriendResidences")
    },
    getFriendResidence: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendResidence")
    },
    getFriendResidences: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendResidences")
    },
    updateFriendResidence: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriendResidence")
    },
    updateFriendResidences: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriendResidences")
    },
    deleteFriendResidence: { _ in
      throw Abort(.notImplemented, reason: "db.deleteFriendResidence")
    },
    deleteAllFriendResidences: {
      throw Abort(.notImplemented, reason: "db.deleteAllFriendResidences")
    },
    createFriendResidenceDuration: { _ in
      throw Abort(.notImplemented, reason: "db.createFriendResidenceDuration")
    },
    createFriendResidenceDurations: { _ in
      throw Abort(.notImplemented, reason: "db.createFriendResidenceDurations")
    },
    getFriendResidenceDuration: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendResidenceDuration")
    },
    getFriendResidenceDurations: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendResidenceDurations")
    },
    updateFriendResidenceDuration: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriendResidenceDuration")
    },
    updateFriendResidenceDurations: { _ in
      throw Abort(.notImplemented, reason: "db.updateFriendResidenceDurations")
    },
    deleteFriendResidenceDuration: { _ in
      throw Abort(.notImplemented, reason: "db.deleteFriendResidenceDuration")
    },
    deleteAllFriendResidenceDurations: {
      throw Abort(.notImplemented, reason: "db.deleteAllFriendResidenceDurations")
    },
    createDocument: { _ in
      throw Abort(.notImplemented, reason: "db.createDocument")
    },
    createDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.createDocuments")
    },
    getDocument: { _ in
      throw Abort(.notImplemented, reason: "db.getDocument")
    },
    getDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.getDocuments")
    },
    updateDocument: { _ in
      throw Abort(.notImplemented, reason: "db.updateDocument")
    },
    updateDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.updateDocuments")
    },
    deleteDocument: { _ in
      throw Abort(.notImplemented, reason: "db.deleteDocument")
    },
    deleteAllDocuments: {
      throw Abort(.notImplemented, reason: "db.deleteAllDocuments")
    },
    createDocumentTag: { _ in
      throw Abort(.notImplemented, reason: "db.createDocumentTag")
    },
    getDocumentTags: { _ in
      throw Abort(.notImplemented, reason: "db.getDocumentTags")
    },
    createRelatedDocument: { _ in
      throw Abort(.notImplemented, reason: "db.createRelatedDocument")
    },
    getRelatedDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.getRelatedDocuments")
    },
    createEdition: { _ in
      throw Abort(.notImplemented, reason: "db.createEdition")
    },
    createEditions: { _ in
      throw Abort(.notImplemented, reason: "db.createEditions")
    },
    getEdition: { _ in
      throw Abort(.notImplemented, reason: "db.getEdition")
    },
    getEditionIsbn: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionIsbn")
    },
    getEditionAudio: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionAudio")
    },
    getEditionEditionImpression: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionEditionImpression")
    },
    getEditions: { _ in
      throw Abort(.notImplemented, reason: "db.getEditions")
    },
    updateEdition: { _ in
      throw Abort(.notImplemented, reason: "db.updateEdition")
    },
    updateEditions: { _ in
      throw Abort(.notImplemented, reason: "db.updateEditions")
    },
    deleteEdition: { _ in
      throw Abort(.notImplemented, reason: "db.deleteEdition")
    },
    deleteAllEditions: {
      throw Abort(.notImplemented, reason: "db.deleteAllEditions")
    },
    createEditionImpression: { _ in
      throw Abort(.notImplemented, reason: "db.createEditionImpression")
    },
    createEditionImpressions: { _ in
      throw Abort(.notImplemented, reason: "db.createEditionImpressions")
    },
    getEditionImpression: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionImpression")
    },
    getEditionImpressions: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionImpressions")
    },
    updateEditionImpression: { _ in
      throw Abort(.notImplemented, reason: "db.updateEditionImpression")
    },
    updateEditionImpressions: { _ in
      throw Abort(.notImplemented, reason: "db.updateEditionImpressions")
    },
    deleteEditionImpression: { _ in
      throw Abort(.notImplemented, reason: "db.deleteEditionImpression")
    },
    deleteAllEditionImpressions: {
      throw Abort(.notImplemented, reason: "db.deleteAllEditionImpressions")
    },
    createEditionChapter: { _ in
      throw Abort(.notImplemented, reason: "db.createEditionChapter")
    },
    createEditionChapters: { _ in
      throw Abort(.notImplemented, reason: "db.createEditionChapters")
    },
    getEditionChapter: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionChapter")
    },
    getEditionChapters: { _ in
      throw Abort(.notImplemented, reason: "db.getEditionChapters")
    },
    updateEditionChapter: { _ in
      throw Abort(.notImplemented, reason: "db.updateEditionChapter")
    },
    updateEditionChapters: { _ in
      throw Abort(.notImplemented, reason: "db.updateEditionChapters")
    },
    deleteEditionChapter: { _ in
      throw Abort(.notImplemented, reason: "db.deleteEditionChapter")
    },
    deleteAllEditionChapters: {
      throw Abort(.notImplemented, reason: "db.deleteAllEditionChapters")
    },
    createAudio: { _ in
      throw Abort(.notImplemented, reason: "db.createAudio")
    },
    createAudios: { _ in
      throw Abort(.notImplemented, reason: "db.createAudios")
    },
    getAudio: { _ in
      throw Abort(.notImplemented, reason: "db.getAudio")
    },
    getAudios: { _ in
      throw Abort(.notImplemented, reason: "db.getAudios")
    },
    updateAudio: { _ in
      throw Abort(.notImplemented, reason: "db.updateAudio")
    },
    updateAudios: { _ in
      throw Abort(.notImplemented, reason: "db.updateAudios")
    },
    deleteAudio: { _ in
      throw Abort(.notImplemented, reason: "db.deleteAudio")
    },
    deleteAllAudios: {
      throw Abort(.notImplemented, reason: "db.deleteAllAudios")
    },
    createAudioPart: { _ in
      throw Abort(.notImplemented, reason: "db.createAudioPart")
    },
    createAudioParts: { _ in
      throw Abort(.notImplemented, reason: "db.createAudioParts")
    },
    getAudioPart: { _ in
      throw Abort(.notImplemented, reason: "db.getAudioPart")
    },
    getAudioParts: { _ in
      throw Abort(.notImplemented, reason: "db.getAudioParts")
    },
    updateAudioPart: { _ in
      throw Abort(.notImplemented, reason: "db.updateAudioPart")
    },
    updateAudioParts: { _ in
      throw Abort(.notImplemented, reason: "db.updateAudioParts")
    },
    deleteAudioPart: { _ in
      throw Abort(.notImplemented, reason: "db.deleteAudioPart")
    },
    deleteAllAudioParts: {
      throw Abort(.notImplemented, reason: "db.deleteAllAudioParts")
    },
    createIsbn: { _ in
      throw Abort(.notImplemented, reason: "db.createIsbn")
    },
    createIsbns: { _ in
      throw Abort(.notImplemented, reason: "db.createIsbns")
    },
    getIsbn: { _ in
      throw Abort(.notImplemented, reason: "db.getIsbn")
    },
    getIsbns: { _ in
      throw Abort(.notImplemented, reason: "db.getIsbns")
    },
    updateIsbn: { _ in
      throw Abort(.notImplemented, reason: "db.updateIsbn")
    },
    updateIsbns: { _ in
      throw Abort(.notImplemented, reason: "db.updateIsbns")
    },
    deleteIsbn: { _ in
      throw Abort(.notImplemented, reason: "db.deleteIsbn")
    },
    deleteAllIsbns: {
      throw Abort(.notImplemented, reason: "db.deleteAllIsbns")
    },
    createArtifactProductionVersion: { _ in
      throw Abort(.notImplemented, reason: "db.createArtifactProductionVersion")
    },
    getArtifactProductionVersions: { _ in
      throw Abort(.notImplemented, reason: "db.getArtifactProductionVersions")
    }
  )
}
