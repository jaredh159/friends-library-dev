import FluentSQL
import Vapor

struct FreeOrderRequestRepository {
  var db: SQLDatabase

  func create(_ request: FreeOrderRequest) async throws {
    try await insert(request)
  }

  func find(_ id: FreeOrderRequest.Id) async throws -> FreeOrderRequest {
    let models = try await select(
      .all,
      from: FreeOrderRequest.self,
      where: (FreeOrderRequest[.id], .equals, .uuid(id))
    )

    guard let first = models.first else { throw DbError.notFound }
    return first
  }
}

struct MockFreeOrderRequestRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func create(_ download: FreeOrderRequest) async throws {
    db.add(download, to: \.freeOrderRequests)
  }

  func find(_ id: FreeOrderRequest.Id) async throws -> FreeOrderRequest {
    try db.find(id, in: \.freeOrderRequests)
  }
}

/// extensions

extension FreeOrderRequestRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try await create($0) }
    client.getFreeOrderRequest = { try await find($0) }
  }
}

extension MockFreeOrderRequestRepository: MockRepository {
  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try await create($0) }
    client.getFreeOrderRequest = { try await find($0) }
  }
}
