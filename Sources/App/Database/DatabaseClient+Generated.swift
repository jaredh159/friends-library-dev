// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    OrderRepository(db: db).assign(client: &client)
    TokenRepository(db: db).assign(client: &client)
    FriendRepository(db: db).assign(client: &client)
    DocumentRepository(db: db).assign(client: &client)
    DownloadRepository(db: db).assign(client: &client)
    DocumentTagModelRepository(db: db).assign(client: &client)
    FreeOrderRequestRepository(db: db).assign(client: &client)
    ArtifactProductionVersionRepository(db: db).assign(client: &client)
    return client
  }

  static var mock: DatabaseClient {
    let mockDb = MockDb()
    var client: DatabaseClient = .notImplemented
    MockOrderRepository(db: mockDb).assign(client: &client)
    MockTokenRepository(db: mockDb).assign(client: &client)
    MockFriendRepository(db: mockDb).assign(client: &client)
    MockDocumentRepository(db: mockDb).assign(client: &client)
    MockDownloadRepository(db: mockDb).assign(client: &client)
    MockDocumentTagModelRepository(db: mockDb).assign(client: &client)
    MockFreeOrderRequestRepository(db: mockDb).assign(client: &client)
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
