// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
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
    client.createToken = { try await tokens.create($0) }
    client.getToken = { try await tokens.find($0) }
    client.createTokenScope = { try await tokenScopes.create($0) }
    client.getTokenScopes = { try await tokenScopes.findAll(where: $0) }
    client.getOrder = { try await orders.find($0) }
    client.getOrders = { try await orders.findAll(where: $0) }
    client.updateOrder = { try await orders.update($0) }
    client.updateOrders = { try await orders.update($0) }
    client.createOrder = { try await orders.create($0) }
    client.createOrders = { try await orders.create($0) }
    client.deleteOrder = { try await orders.delete($0) }
    client.deleteAllOrders = { try await orders.deleteAll() }
    client.createOrderItem = { try await orderItems.create($0) }
    client.createOrderItems = { try await orderItems.create($0) }
    client.getOrderItem = { try await orderItems.find($0) }
    client.getOrderItems = { try await orderItems.findAll(where: $0) }
    client.updateOrderItem = { try await orderItems.update($0) }
    client.updateOrderItems = { try await orderItems.update($0) }
    client.deleteOrderItem = { try await orderItems.delete($0) }
    client.createFreeOrderRequest = { try await freeOrderRequests.create($0) }
    client.getFreeOrderRequest = { try await freeOrderRequests.find($0) }
    client.createDownload = { try await downloads.create($0) }
    client.createDownloads = { try await downloads.create($0) }
    client.getDownload = { try await downloads.find($0) }
    client.getDownloads = { try await downloads.findAll(where: $0) }
    client.updateDownload = { try await downloads.update($0) }
    client.updateDownloads = { try await downloads.update($0) }
    client.deleteDownload = { try await downloads.delete($0) }
    client.deleteAllDownloads = { try await downloads.deleteAll() }
    client.createFriend = { try await friends.create($0) }
    client.createFriends = { try await friends.create($0) }
    client.getFriend = { try await friends.find($0) }
    client.getFriends = { try await friends.findAll(where: $0) }
    client.updateFriend = { try await friends.update($0) }
    client.updateFriends = { try await friends.update($0) }
    client.deleteFriend = { try await friends.delete($0) }
    client.deleteAllFriends = { try await friends.deleteAll() }
    client.createFriendQuote = { try await friendQuotes.create($0) }
    client.createFriendQuotes = { try await friendQuotes.create($0) }
    client.getFriendQuote = { try await friendQuotes.find($0) }
    client.getFriendQuotes = { try await friendQuotes.findAll(where: $0) }
    client.updateFriendQuote = { try await friendQuotes.update($0) }
    client.updateFriendQuotes = { try await friendQuotes.update($0) }
    client.deleteFriendQuote = { try await friendQuotes.delete($0) }
    client.deleteAllFriendQuotes = { try await friendQuotes.deleteAll() }
    client.createFriendResidence = { try await friendResidences.create($0) }
    client.createFriendResidences = { try await friendResidences.create($0) }
    client.getFriendResidence = { try await friendResidences.find($0) }
    client.getFriendResidences = { try await friendResidences.findAll(where: $0) }
    client.updateFriendResidence = { try await friendResidences.update($0) }
    client.updateFriendResidences = { try await friendResidences.update($0) }
    client.deleteFriendResidence = { try await friendResidences.delete($0) }
    client.deleteAllFriendResidences = { try await friendResidences.deleteAll() }
    client.createFriendResidenceDuration = { try await friendResidenceDurations.create($0) }
    client.createFriendResidenceDurations = { try await friendResidenceDurations.create($0) }
    client.getFriendResidenceDuration = { try await friendResidenceDurations.find($0) }
    client.getFriendResidenceDurations = { try await friendResidenceDurations.findAll(where: $0) }
    client.updateFriendResidenceDuration = { try await friendResidenceDurations.update($0) }
    client.updateFriendResidenceDurations = { try await friendResidenceDurations.update($0) }
    client.deleteFriendResidenceDuration = { try await friendResidenceDurations.delete($0) }
    client.deleteAllFriendResidenceDurations = { try await friendResidenceDurations.deleteAll() }
    client.createDocument = { try await documents.create($0) }
    client.createDocuments = { try await documents.create($0) }
    client.getDocument = { try await documents.find($0) }
    client.getDocuments = { try await documents.findAll(where: $0) }
    client.updateDocument = { try await documents.update($0) }
    client.updateDocuments = { try await documents.update($0) }
    client.deleteDocument = { try await documents.delete($0) }
    client.deleteAllDocuments = { try await documents.deleteAll() }
    client.createDocumentTag = { try await documentTags.create($0) }
    client.getDocumentTags = { try await documentTags.findAll(where: $0) }
    client.createRelatedDocument = { try await relatedDocuments.create($0) }
    client.getRelatedDocuments = { try await relatedDocuments.findAll(where: $0) }
    client.createEdition = { try await editions.create($0) }
    client.createEditions = { try await editions.create($0) }
    client.getEdition = { try await editions.find($0) }
    client.getEditions = { try await editions.findAll(where: $0) }
    client.updateEdition = { try await editions.update($0) }
    client.updateEditions = { try await editions.update($0) }
    client.deleteEdition = { try await editions.delete($0) }
    client.deleteAllEditions = { try await editions.deleteAll() }
    client.createEditionImpression = { try await editionImpressions.create($0) }
    client.createEditionImpressions = { try await editionImpressions.create($0) }
    client.getEditionImpression = { try await editionImpressions.find($0) }
    client.getEditionImpressions = { try await editionImpressions.findAll(where: $0) }
    client.updateEditionImpression = { try await editionImpressions.update($0) }
    client.updateEditionImpressions = { try await editionImpressions.update($0) }
    client.deleteEditionImpression = { try await editionImpressions.delete($0) }
    client.deleteAllEditionImpressions = { try await editionImpressions.deleteAll() }
    client.createEditionChapter = { try await editionChapters.create($0) }
    client.createEditionChapters = { try await editionChapters.create($0) }
    client.getEditionChapter = { try await editionChapters.find($0) }
    client.getEditionChapters = { try await editionChapters.findAll(where: $0) }
    client.updateEditionChapter = { try await editionChapters.update($0) }
    client.updateEditionChapters = { try await editionChapters.update($0) }
    client.deleteEditionChapter = { try await editionChapters.delete($0) }
    client.deleteAllEditionChapters = { try await editionChapters.deleteAll() }
    client.createAudio = { try await audios.create($0) }
    client.createAudios = { try await audios.create($0) }
    client.getAudio = { try await audios.find($0) }
    client.getAudios = { try await audios.findAll(where: $0) }
    client.updateAudio = { try await audios.update($0) }
    client.updateAudios = { try await audios.update($0) }
    client.deleteAudio = { try await audios.delete($0) }
    client.deleteAllAudios = { try await audios.deleteAll() }
    client.createAudioPart = { try await audioParts.create($0) }
    client.createAudioParts = { try await audioParts.create($0) }
    client.getAudioPart = { try await audioParts.find($0) }
    client.getAudioParts = { try await audioParts.findAll(where: $0) }
    client.updateAudioPart = { try await audioParts.update($0) }
    client.updateAudioParts = { try await audioParts.update($0) }
    client.deleteAudioPart = { try await audioParts.delete($0) }
    client.deleteAllAudioParts = { try await audioParts.deleteAll() }
    client.createIsbn = { try await isbns.create($0) }
    client.createIsbns = { try await isbns.create($0) }
    client.getIsbn = { try await isbns.find($0) }
    client.getIsbns = { try await isbns.findAll(where: $0) }
    client.updateIsbn = { try await isbns.update($0) }
    client.updateIsbns = { try await isbns.update($0) }
    client.deleteIsbn = { try await isbns.delete($0) }
    client.deleteAllIsbns = { try await isbns.deleteAll() }
    client.createArtifactProductionVersion = { try await artifactProductionVersions.create($0) }
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
    return client
  }

  static var mock: DatabaseClient {
    let db = MockDb()
    var client: DatabaseClient = .notImplemented
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
    client.createToken = { try await tokens.create($0) }
    client.getToken = { try await tokens.find($0) }
    client.createTokenScope = { try await tokenScopes.create($0) }
    client.getTokenScopes = { try await tokenScopes.findAll(where: $0) }
    client.getOrder = { try await orders.find($0) }
    client.getOrders = { try await orders.findAll(where: $0) }
    client.updateOrder = { try await orders.update($0) }
    client.updateOrders = { try await orders.update($0) }
    client.createOrder = { try await orders.create($0) }
    client.createOrders = { try await orders.create($0) }
    client.deleteOrder = { try await orders.delete($0) }
    client.deleteAllOrders = { try await orders.deleteAll() }
    client.createOrderItem = { try await orderItems.create($0) }
    client.createOrderItems = { try await orderItems.create($0) }
    client.getOrderItem = { try await orderItems.find($0) }
    client.getOrderItems = { try await orderItems.findAll(where: $0) }
    client.updateOrderItem = { try await orderItems.update($0) }
    client.updateOrderItems = { try await orderItems.update($0) }
    client.deleteOrderItem = { try await orderItems.delete($0) }
    client.createFreeOrderRequest = { try await freeOrderRequests.create($0) }
    client.getFreeOrderRequest = { try await freeOrderRequests.find($0) }
    client.createDownload = { try await downloads.create($0) }
    client.createDownloads = { try await downloads.create($0) }
    client.getDownload = { try await downloads.find($0) }
    client.getDownloads = { try await downloads.findAll(where: $0) }
    client.updateDownload = { try await downloads.update($0) }
    client.updateDownloads = { try await downloads.update($0) }
    client.deleteDownload = { try await downloads.delete($0) }
    client.deleteAllDownloads = { try await downloads.deleteAll() }
    client.createFriend = { try await friends.create($0) }
    client.createFriends = { try await friends.create($0) }
    client.getFriend = { try await friends.find($0) }
    client.getFriends = { try await friends.findAll(where: $0) }
    client.updateFriend = { try await friends.update($0) }
    client.updateFriends = { try await friends.update($0) }
    client.deleteFriend = { try await friends.delete($0) }
    client.deleteAllFriends = { try await friends.deleteAll() }
    client.createFriendQuote = { try await friendQuotes.create($0) }
    client.createFriendQuotes = { try await friendQuotes.create($0) }
    client.getFriendQuote = { try await friendQuotes.find($0) }
    client.getFriendQuotes = { try await friendQuotes.findAll(where: $0) }
    client.updateFriendQuote = { try await friendQuotes.update($0) }
    client.updateFriendQuotes = { try await friendQuotes.update($0) }
    client.deleteFriendQuote = { try await friendQuotes.delete($0) }
    client.deleteAllFriendQuotes = { try await friendQuotes.deleteAll() }
    client.createFriendResidence = { try await friendResidences.create($0) }
    client.createFriendResidences = { try await friendResidences.create($0) }
    client.getFriendResidence = { try await friendResidences.find($0) }
    client.getFriendResidences = { try await friendResidences.findAll(where: $0) }
    client.updateFriendResidence = { try await friendResidences.update($0) }
    client.updateFriendResidences = { try await friendResidences.update($0) }
    client.deleteFriendResidence = { try await friendResidences.delete($0) }
    client.deleteAllFriendResidences = { try await friendResidences.deleteAll() }
    client.createFriendResidenceDuration = { try await friendResidenceDurations.create($0) }
    client.createFriendResidenceDurations = { try await friendResidenceDurations.create($0) }
    client.getFriendResidenceDuration = { try await friendResidenceDurations.find($0) }
    client.getFriendResidenceDurations = { try await friendResidenceDurations.findAll(where: $0) }
    client.updateFriendResidenceDuration = { try await friendResidenceDurations.update($0) }
    client.updateFriendResidenceDurations = { try await friendResidenceDurations.update($0) }
    client.deleteFriendResidenceDuration = { try await friendResidenceDurations.delete($0) }
    client.deleteAllFriendResidenceDurations = { try await friendResidenceDurations.deleteAll() }
    client.createDocument = { try await documents.create($0) }
    client.createDocuments = { try await documents.create($0) }
    client.getDocument = { try await documents.find($0) }
    client.getDocuments = { try await documents.findAll(where: $0) }
    client.updateDocument = { try await documents.update($0) }
    client.updateDocuments = { try await documents.update($0) }
    client.deleteDocument = { try await documents.delete($0) }
    client.deleteAllDocuments = { try await documents.deleteAll() }
    client.createDocumentTag = { try await documentTags.create($0) }
    client.getDocumentTags = { try await documentTags.findAll(where: $0) }
    client.createRelatedDocument = { try await relatedDocuments.create($0) }
    client.getRelatedDocuments = { try await relatedDocuments.findAll(where: $0) }
    client.createEdition = { try await editions.create($0) }
    client.createEditions = { try await editions.create($0) }
    client.getEdition = { try await editions.find($0) }
    client.getEditions = { try await editions.findAll(where: $0) }
    client.updateEdition = { try await editions.update($0) }
    client.updateEditions = { try await editions.update($0) }
    client.deleteEdition = { try await editions.delete($0) }
    client.deleteAllEditions = { try await editions.deleteAll() }
    client.createEditionImpression = { try await editionImpressions.create($0) }
    client.createEditionImpressions = { try await editionImpressions.create($0) }
    client.getEditionImpression = { try await editionImpressions.find($0) }
    client.getEditionImpressions = { try await editionImpressions.findAll(where: $0) }
    client.updateEditionImpression = { try await editionImpressions.update($0) }
    client.updateEditionImpressions = { try await editionImpressions.update($0) }
    client.deleteEditionImpression = { try await editionImpressions.delete($0) }
    client.deleteAllEditionImpressions = { try await editionImpressions.deleteAll() }
    client.createEditionChapter = { try await editionChapters.create($0) }
    client.createEditionChapters = { try await editionChapters.create($0) }
    client.getEditionChapter = { try await editionChapters.find($0) }
    client.getEditionChapters = { try await editionChapters.findAll(where: $0) }
    client.updateEditionChapter = { try await editionChapters.update($0) }
    client.updateEditionChapters = { try await editionChapters.update($0) }
    client.deleteEditionChapter = { try await editionChapters.delete($0) }
    client.deleteAllEditionChapters = { try await editionChapters.deleteAll() }
    client.createAudio = { try await audios.create($0) }
    client.createAudios = { try await audios.create($0) }
    client.getAudio = { try await audios.find($0) }
    client.getAudios = { try await audios.findAll(where: $0) }
    client.updateAudio = { try await audios.update($0) }
    client.updateAudios = { try await audios.update($0) }
    client.deleteAudio = { try await audios.delete($0) }
    client.deleteAllAudios = { try await audios.deleteAll() }
    client.createAudioPart = { try await audioParts.create($0) }
    client.createAudioParts = { try await audioParts.create($0) }
    client.getAudioPart = { try await audioParts.find($0) }
    client.getAudioParts = { try await audioParts.findAll(where: $0) }
    client.updateAudioPart = { try await audioParts.update($0) }
    client.updateAudioParts = { try await audioParts.update($0) }
    client.deleteAudioPart = { try await audioParts.delete($0) }
    client.deleteAllAudioParts = { try await audioParts.deleteAll() }
    client.createIsbn = { try await isbns.create($0) }
    client.createIsbns = { try await isbns.create($0) }
    client.getIsbn = { try await isbns.find($0) }
    client.getIsbns = { try await isbns.findAll(where: $0) }
    client.updateIsbn = { try await isbns.update($0) }
    client.updateIsbns = { try await isbns.update($0) }
    client.deleteIsbn = { try await isbns.delete($0) }
    client.deleteAllIsbns = { try await isbns.deleteAll() }
    client.createArtifactProductionVersion = { try await artifactProductionVersions.create($0) }
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
    return client
  }

  static let notImplemented = DatabaseClient(
    createToken: { _ in
      throw Abort(.notImplemented, reason: "db.createToken")
    },
    getToken: { _ in
      throw Abort(.notImplemented, reason: "db.getToken")
    },
    getTokenByValue: { _ in
      throw Abort(.notImplemented, reason: "db.getTokenByValue")
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
    getOrdersByPrintJobStatus: { _ in
      throw Abort(.notImplemented, reason: "db.getOrdersByPrintJobStatus")
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
    createOrderWithItems: { _ in
      throw Abort(.notImplemented, reason: "db.createOrderWithItems")
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
    getLatestArtifactProductionVersion: {
      throw Abort(.notImplemented, reason: "db.getLatestArtifactProductionVersion")
    }
  )
}
