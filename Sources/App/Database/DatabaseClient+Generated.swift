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
    EditionChapterRepository(db: db).assign(client: &client)
    DocumentTagModelRepository(db: db).assign(client: &client)
    FreeOrderRequestRepository(db: db).assign(client: &client)
    EditionImpressionRepository(db: db).assign(client: &client)
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
    MockEditionChapterRepository(db: mockDb).assign(client: &client)
    MockDocumentTagModelRepository(db: mockDb).assign(client: &client)
    MockFreeOrderRequestRepository(db: mockDb).assign(client: &client)
    MockEditionImpressionRepository(db: mockDb).assign(client: &client)
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
    deleteAllOrders: {
      throw Abort(.notImplemented, reason: "db.deleteAllOrders")
    },
    createOrderWithItems: { _ in
      throw Abort(.notImplemented, reason: "db.createOrderWithItems")
    },
    getOrder: { _ in
      throw Abort(.notImplemented, reason: "db.getOrder")
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
    createFreeOrderRequest: { _ in
      throw Abort(.notImplemented, reason: "db.createFreeOrderRequest")
    },
    getFreeOrderRequest: { _ in
      throw Abort(.notImplemented, reason: "db.getFreeOrderRequest")
    },
    createDownload: { _ in
      throw Abort(.notImplemented, reason: "db.createDownload")
    },
    getDownload: { _ in
      throw Abort(.notImplemented, reason: "db.getDownload")
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
    createDocument: { _ in
      throw Abort(.notImplemented, reason: "db.createDocument")
    },
    createDocuments: { _ in
      throw Abort(.notImplemented, reason: "db.createDocuments")
    },
    getDocument: { _ in
      throw Abort(.notImplemented, reason: "db.getDocument")
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
    createEdition: { _ in
      throw Abort(.notImplemented, reason: "db.createEdition")
    },
    createEditions: { _ in
      throw Abort(.notImplemented, reason: "db.createEditions")
    },
    getEdition: { _ in
      throw Abort(.notImplemented, reason: "db.getEdition")
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
