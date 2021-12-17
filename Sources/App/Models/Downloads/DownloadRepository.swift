import FluentSQL
import Vapor

struct DownloadRepository {
  var db: SQLDatabase

  func create(_ download: Download) throws -> Future<Void> {
    throw Abort(.notImplemented)
    // @TODO, FK issues with documents, do those first
    // try insert(
    //   into: Download.tableName,
    //   values: [
    //     Download[.id]: .id(download)
    //   ]
    // )
  }

  func find(_ id: Download.Id) throws -> Future<Download> {
    throw Abort(.notImplemented)
  }
}

struct MockDownloadRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func create(_ download: Download) throws -> Future<Void> {
    future(db.add(download, to: \.downloads))
  }

  func find(_ id: Download.Id) throws -> Future<Download> {
    future(try db.find(id, in: \.downloads))
  }
}

/// extensions

extension DownloadRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createDownload = { try create($0) }
    client.getDownload = { try find($0) }
  }
}

extension MockDownloadRepository: MockRepository {
  func assign(client: inout DatabaseClient) {

    client.createDownload = { try create($0) }
    client.getDownload = { try find($0) }
  }
}
