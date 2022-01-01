import FluentSQL
import Vapor

struct DocumentRepository: LiveRepository {
  typealias Model = Document
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createDocument = { try await create($0) }
    client.createDocuments = { try await create($0) }
    client.getDocument = { try await find($0) }
    client.getDocuments = { try await select() }
    client.updateDocument = { try await update($0) }
    client.updateDocuments = { try await update($0) }
    client.deleteDocument = { try await delete($0) }
    client.deleteAllDocuments = { try await deleteAll() }
  }
}

struct MockDocumentRepository: MockRepository {
  typealias Model = Document
  var db: MockDb
  var models: ModelsPath { \.documents }

  func assign(client: inout DatabaseClient) {
    client.createDocument = { try await create($0) }
    client.createDocuments = { try await create($0) }
    client.getDocument = { try await find($0) }
    client.getDocuments = { try await select() }
    client.updateDocument = { try await update($0) }
    client.updateDocuments = { try await update($0) }
    client.deleteDocument = { try await delete($0) }
    client.deleteAllDocuments = { try await deleteAll() }
  }
}
