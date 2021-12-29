import FluentSQL
import Vapor

struct DownloadRepository {
  var db: SQLDatabase
}

struct MockDownloadRepository {
  var db: MockDb

  func create(_ download: Download) async throws {
    db.add(download, to: \.downloads)
  }

  func find(_ id: Download.Id) async throws -> Download {
    try db.find(id, in: \.downloads)
  }
}

/// extensions

extension DownloadRepository: LiveRepository {
  typealias Model = Download

  func assign(client: inout DatabaseClient) {
    client.createDownload = { try await create($0) }
    client.getDownload = { try await find($0) }
  }
}

extension MockDownloadRepository: MockRepository {
  typealias Model = Download

  func assign(client: inout DatabaseClient) {
    client.createDownload = { try await create($0) }
    client.getDownload = { try await find($0) }
  }
}
