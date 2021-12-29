import FluentSQL
import Vapor

struct FreeOrderRequestRepository: LiveRepository {
  typealias Model = FreeOrderRequest
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try await create($0) }
    client.getFreeOrderRequest = { try await find($0) }
  }
}

struct MockFreeOrderRequestRepository: MockRepository {
  typealias Model = FreeOrderRequest
  var db: MockDb
  var models: ModelsPath { \.freeOrderRequests }

  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try await create($0) }
    client.getFreeOrderRequest = { try await find($0) }
  }
}
