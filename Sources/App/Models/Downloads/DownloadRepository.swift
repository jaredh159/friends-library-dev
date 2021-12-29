import FluentSQL
import Vapor

struct DownloadRepository: LiveRepository {
  typealias Model = Download
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createDownload = { try await create($0) }
    client.getDownload = { try await find($0) }
  }
}

struct MockDownloadRepository: MockRepository {
  typealias Model = Download
  var db: MockDb
  var models: ModelsPath { \.downloads }

  func assign(client: inout DatabaseClient) {
    client.createDownload = { try await create($0) }
    client.getDownload = { try await find($0) }
  }
}
