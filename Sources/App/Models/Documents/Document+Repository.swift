import FluentSQL
import Vapor

extension Repository where Model == Document {
  func getEditions(_ id: Document.Id) async throws -> [Edition] {
    try await findChildren(id, fk: Edition[.documentId])
  }

  func assign(client: inout DatabaseClient) {
    client.getDocumentEditions = { try await getEditions($0) }
  }
}

extension MockRepository where Model == Document {
  func getEditions(_ id: Document.Id) async throws -> [Edition] {
    db.find(where: { $0.documentId == id }, in: \.editions)
  }

  func assign(client: inout DatabaseClient) {
    client.getDocumentEditions = { try await getEditions($0) }
  }
}
