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
  var deleteAllOrders: () throws -> Future<Void>
  var createOrder: (Order) throws -> Future<Void>
  var getOrder: (Order.Id) throws -> Future<Order>
  var getOrdersByPrintJobStatus: (Order.PrintJobStatus) throws -> Future<[Order]>
  var updateOrder: (UpdateOrderInput) throws -> Future<Order>

  // free order requests
  var createFreeOrderRequest: (FreeOrderRequest) async throws -> Void
  var getFreeOrderRequest: (FreeOrderRequest.Id) async throws -> FreeOrderRequest

  // downloads
  var createDownload: (Download) throws -> Future<Void>
  var getDownload: (Download.Id) throws -> Future<Download>

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
    createOrder: { _ in throw Abort(.notImplemented) },
    getOrder: { _ in throw Abort(.notImplemented) },
    getOrdersByPrintJobStatus: { _ in throw Abort(.notImplemented) },
    updateOrder: { _ in throw Abort(.notImplemented) },

    // free order requests
    createFreeOrderRequest: { _ in throw Abort(.notImplemented) },
    getFreeOrderRequest: { _ in throw Abort(.notImplemented) },

    // downloads
    createDownload: { _ in throw Abort(.notImplemented) },
    getDownload: { _ in throw Abort(.notImplemented) },

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
  static func mock(eventLoop el: EventLoop) -> DatabaseClient {
    let mockDb = MockDb()
    var client: DatabaseClient = .notImplemented
    MockTokenRepository(db: mockDb, eventLoop: el).assign(client: &client)
    MockOrderRepository(db: mockDb, eventLoop: el).assign(client: &client)
    MockDownloadRepository(db: mockDb, eventLoop: el).assign(client: &client)
    MockFreeOrderRequestRepository(db: mockDb, eventLoop: el).assign(client: &client)
    MockArtifactProductionVersionRepository(db: mockDb, eventLoop: el).assign(client: &client)
    return client
  }
}
