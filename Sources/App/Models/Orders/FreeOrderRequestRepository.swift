import FluentSQL
import Vapor

struct FreeOrderRequestRepository {
  var db: SQLDatabase

  func create(_ request: FreeOrderRequest) throws -> Future<Void> {
    try insert(
      into: FreeOrderRequest.tableName,
      values: [
        FreeOrderRequest[.id]: .id(request),
        FreeOrderRequest[.email]: .string(request.email.rawValue),
        FreeOrderRequest[.name]: .string(request.name),
        FreeOrderRequest[.aboutRequester]: .string(request.aboutRequester),
        FreeOrderRequest[.requestedBooks]: .string(request.requestedBooks),
        FreeOrderRequest[.addressStreet]: .string(request.addressStreet),
        FreeOrderRequest[.addressStreet2]: .string(request.addressStreet2),
        FreeOrderRequest[.addressCity]: .string(request.addressCity),
        FreeOrderRequest[.addressState]: .string(request.addressState),
        FreeOrderRequest[.addressZip]: .string(request.addressZip),
        FreeOrderRequest[.addressCountry]: .string(request.addressCountry),
        FreeOrderRequest[.source]: .string(request.source),
        FreeOrderRequest[.createdAt]: .currentTimestamp,
        FreeOrderRequest[.updatedAt]: .currentTimestamp,
      ]
    )
  }

  func find(_ id: FreeOrderRequest.Id) throws -> Future<FreeOrderRequest> {
    try select(
      .all,
      from: FreeOrderRequest.self,
      where: (FreeOrderRequest[.id], .equals, .uuid(id))
    ).flatMapThrowing { reqs in
      guard let req = reqs.first else { throw DbError.notFound }
      return req
    }
  }
}

struct MockFreeOrderRequestRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func create(_ download: FreeOrderRequest) throws -> Future<Void> {
    future(db.add(download, to: \.freeOrderRequests))
  }

  func find(_ id: FreeOrderRequest.Id) throws -> Future<FreeOrderRequest> {
    future(try db.find(id, in: \.freeOrderRequests))
  }
}

/// extensions

extension FreeOrderRequestRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try create($0) }
    client.getFreeOrderRequest = { try find($0) }
  }
}

extension MockFreeOrderRequestRepository: MockRepository {
  func assign(client: inout DatabaseClient) {
    client.createFreeOrderRequest = { try create($0) }
    client.getFreeOrderRequest = { try find($0) }
  }
}
