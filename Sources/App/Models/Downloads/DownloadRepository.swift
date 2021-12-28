import FluentSQL
import Vapor

struct DownloadRepository {
  var db: SQLDatabase

  func create(_ download: Download) async throws {
    throw Abort(.notImplemented)
    // @TODO, FK issues with documents, do those first
    // try insert(
    //   into: Download.tableName,
    //   values: [
    //     Download[.id]: .id(download)
    //   ]
    // )
  }

  func find(_ id: Download.Id) async throws -> Download {
    throw Abort(.notImplemented)
  }
}

struct MockDownloadRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func create(_ download: Download) async throws {
    db.add(download, to: \.downloads)
  }

  func find(_ id: Download.Id) async throws -> Download {
    try db.find(id, in: \.downloads)
  }
}

/// extensions

extension DownloadRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createDownload = { try await create($0) }
    client.getDownload = { try await find($0) }
  }
}

extension MockDownloadRepository: MockRepository {
  func assign(client: inout DatabaseClient) {

    client.createDownload = { try await create($0) }
    client.getDownload = { try await find($0) }
  }
}
