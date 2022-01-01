import Fluent
import FluentSQL
import Tagged
import Vapor

struct DatabaseClient {
  // tokens
  var createToken: (Token) async throws -> Void
  var getTokenByValue: (Token.Value) async throws -> Token
  var createTokenScope: (TokenScope) async throws -> Void
  var getTokenScopes: (Token.Id) async throws -> [TokenScope]

  // orders
  var deleteAllOrders: () async throws -> Void
  var createOrderWithItems: (Order) async throws -> Void
  var getOrder: (Order.Id) async throws -> Order
  var getOrdersByPrintJobStatus: (Order.PrintJobStatus) async throws -> [Order]
  var updateOrder: (Order) async throws -> Order
  var updateOrders: ([Order]) async throws -> [Order]

  // free order requests
  var createFreeOrderRequest: (FreeOrderRequest) async throws -> Void
  var getFreeOrderRequest: (FreeOrderRequest.Id) async throws -> FreeOrderRequest

  // downloads
  var createDownload: (Download) async throws -> Void
  var getDownload: (Download.Id) async throws -> Download

  // documents
  var createDocumentTagModels: ([DocumentTagModel]) async throws -> Void

  // artifact production versions
  var createArtifactProductionVersion: (ArtifactProductionVersion) async throws -> Void
  var getLatestArtifactProductionVersion: () async throws -> ArtifactProductionVersion
}

extension DatabaseClient {
  static let notImplemented = DatabaseClient(
    // tokens
    createToken: { _ in throw Abort(.notImplemented) },
    getTokenByValue: { _ in throw Abort(.notImplemented) },
    createTokenScope: { _ in throw Abort(.notImplemented) },
    getTokenScopes: { _ in throw Abort(.notImplemented) },

    // orders
    deleteAllOrders: { throw Abort(.notImplemented) },
    createOrderWithItems: { _ in throw Abort(.notImplemented) },
    getOrder: { _ in throw Abort(.notImplemented) },
    getOrdersByPrintJobStatus: { _ in throw Abort(.notImplemented) },
    updateOrder: { _ in throw Abort(.notImplemented) },
    updateOrders: { _ in throw Abort(.notImplemented) },

    // free order requests
    createFreeOrderRequest: { _ in throw Abort(.notImplemented) },
    getFreeOrderRequest: { _ in throw Abort(.notImplemented) },

    // downloads
    createDownload: { _ in throw Abort(.notImplemented) },
    getDownload: { _ in throw Abort(.notImplemented) },

    // documents
    createDocumentTagModels: { _ in throw Abort(.notImplemented) },

    // artifact production versions
    createArtifactProductionVersion: { _ in throw Abort(.notImplemented) },
    getLatestArtifactProductionVersion: { throw Abort(.notImplemented) }
  )
}

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    TokenRepository(db: db).assign(client: &client)
    OrderRepository(db: db).assign(client: &client)
    DownloadRepository(db: db).assign(client: &client)
    FreeOrderRequestRepository(db: db).assign(client: &client)
    ArtifactProductionVersionRepository(db: db).assign(client: &client)
    return client
  }
}

extension DatabaseClient {
  static var mock: DatabaseClient {
    let mockDb = MockDb()
    var client: DatabaseClient = .notImplemented
    MockTokenRepository(db: mockDb).assign(client: &client)
    MockOrderRepository(db: mockDb).assign(client: &client)
    MockDownloadRepository(db: mockDb).assign(client: &client)
    MockFreeOrderRequestRepository(db: mockDb).assign(client: &client)
    MockArtifactProductionVersionRepository(db: mockDb).assign(client: &client)
    return client
  }
}
