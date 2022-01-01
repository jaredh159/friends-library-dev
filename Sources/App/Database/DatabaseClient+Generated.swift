// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    OrderRepository(db: db).assign(client: &client)
    TokenRepository(db: db).assign(client: &client)
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
