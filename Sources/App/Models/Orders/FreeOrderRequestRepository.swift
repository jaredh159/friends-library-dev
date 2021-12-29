import FluentSQL
import Vapor

struct FreeOrderRequestRepository {
  var db: SQLDatabase
}

struct MockFreeOrderRequestRepository {
  var db: MockDb

  func create(_ download: FreeOrderRequest) async throws {
    db.add(download, to: \.freeOrderRequests)
  }

  func find(_ id: FreeOrderRequest.Id) async throws -> FreeOrderRequest {
    try db.find(id, in: \.freeOrderRequests)
  }
}

/// extensions

extension FreeOrderRequestRepository: LiveRepository {
  typealias Model = FreeOrderRequest

  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try await create($0) }
    client.getFreeOrderRequest = { try await find($0) }
  }
}

extension MockFreeOrderRequestRepository: MockRepository {
  typealias Model = FreeOrderRequest

  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try await create($0) }
    client.getFreeOrderRequest = { try await find($0) }
  }
}
