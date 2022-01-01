import FluentSQL
import Vapor

struct DocumentTagModelRepository: LiveRepository {
  typealias Model = DocumentTagModel
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createDocumentTagModels = { try await create($0) }
  }
}

struct MockDocumentTagModelRepository: MockRepository {
  typealias Model = DocumentTagModel
  var db: MockDb
  var models: ModelsPath { \.documentTagModels }

  func assign(client: inout DatabaseClient) {
    client.createDocumentTagModels = { try await create($0) }
  }
}
