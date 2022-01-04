// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    IsbnRepository(db: db).assign(client: &client)
    AudioRepository(db: db).assign(client: &client)
    OrderRepository(db: db).assign(client: &client)
    TokenRepository(db: db).assign(client: &client)
    FriendRepository(db: db).assign(client: &client)
    EditionRepository(db: db).assign(client: &client)
    DocumentRepository(db: db).assign(client: &client)
    DownloadRepository(db: db).assign(client: &client)
    AudioPartRepository(db: db).assign(client: &client)
    FriendQuoteRepository(db: db).assign(client: &client)
    EditionChapterRepository(db: db).assign(client: &client)
    FriendResidenceRepository(db: db).assign(client: &client)
    DocumentTagModelRepository(db: db).assign(client: &client)
    FreeOrderRequestRepository(db: db).assign(client: &client)
    EditionImpressionRepository(db: db).assign(client: &client)
    FriendResidenceDurationRepository(db: db).assign(client: &client)
    ArtifactProductionVersionRepository(db: db).assign(client: &client)
    return client
  }

  static var mock: DatabaseClient {
    let mockDb = MockDb()
    var client: DatabaseClient = .notImplemented
    MockIsbnRepository(db: mockDb).assign(client: &client)
    MockAudioRepository(db: mockDb).assign(client: &client)
    MockOrderRepository(db: mockDb).assign(client: &client)
    MockTokenRepository(db: mockDb).assign(client: &client)
    MockFriendRepository(db: mockDb).assign(client: &client)
    MockEditionRepository(db: mockDb).assign(client: &client)
    MockDocumentRepository(db: mockDb).assign(client: &client)
    MockDownloadRepository(db: mockDb).assign(client: &client)
    MockAudioPartRepository(db: mockDb).assign(client: &client)
    MockFriendQuoteRepository(db: mockDb).assign(client: &client)
    MockEditionChapterRepository(db: mockDb).assign(client: &client)
    MockFriendResidenceRepository(db: mockDb).assign(client: &client)
    MockDocumentTagModelRepository(db: mockDb).assign(client: &client)
    MockFreeOrderRequestRepository(db: mockDb).assign(client: &client)
    MockEditionImpressionRepository(db: mockDb).assign(client: &client)
    MockFriendResidenceDurationRepository(db: mockDb).assign(client: &client)
    MockArtifactProductionVersionRepository(db: mockDb).assign(client: &client)
    return client
  }

  static let notImplemented = DatabaseClient(
    createToken: { _ in
      throw Abort(.notImplemented, reason: "db.createToken")
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
    getOrders: {
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
    getOrderItems: {
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
    deleteAllOrderItems: {
      throw Abort(.notImplemented, reason: "db.deleteAllOrderItems")
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
    getDownloads: {
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
    getFriends: {
      throw Abort(.notImplemented, reason: "db.getFriends")
    },
    getFriendDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.getFriendDocuments")
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
    getFriendQuotes: {
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
    getFriendResidences: {
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
    getFriendResidenceDurations: {
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
    getDocumentEditions: { _ in
      throw Abort(.notImplemented, reason: "db.getDocumentEditions")
    },
    getDocuments: {
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
    createRelatedDocument: { _ in
      throw Abort(.notImplemented, reason: "db.createRelatedDocument")
    },
    createRelatedDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.createRelatedDocuments")
    },
    getRelatedDocument: { _ in
      throw Abort(.notImplemented, reason: "db.getRelatedDocument")
    },
    getRelatedDocuments: {
      throw Abort(.notImplemented, reason: "db.getRelatedDocuments")
    },
    updateRelatedDocument: { _ in
      throw Abort(.notImplemented, reason: "db.updateRelatedDocument")
    },
    updateRelatedDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.updateRelatedDocuments")
    },
    deleteRelatedDocument: { _ in
      throw Abort(.notImplemented, reason: "db.deleteRelatedDocument")
    },
    deleteAllRelatedDocuments: {
      throw Abort(.notImplemented, reason: "db.deleteAllRelatedDocuments")
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
    getEditions: {
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
    getEditionImpressions: {
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
    getEditionChapters: {
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
    getAudios: {
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
    getAudioParts: {
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
    getIsbns: {
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
    createDocumentTagModels: { _ in
      throw Abort(.notImplemented, reason: "db.createDocumentTagModels")
    },
    createArtifactProductionVersion: { _ in
      throw Abort(.notImplemented, reason: "db.createArtifactProductionVersion")
    },
    getLatestArtifactProductionVersion: {
      throw Abort(.notImplemented, reason: "db.getLatestArtifactProductionVersion")
    }
  )
}
