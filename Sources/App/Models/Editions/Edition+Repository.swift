import FluentSQL
import Vapor

extension Repository where Model == Edition {
  func getIsbn(_ id: Edition.Id) async throws -> Isbn? {
    try await findOptionalChild(id, fk: Isbn[.editionId])
  }

  func assign(client: inout DatabaseClient) {
    client.getEditionIsbn = { try await getIsbn($0) }
  }
}

extension MockRepository where Model == Edition {
  func getIsbn(_ id: Edition.Id) async throws -> Isbn? {
    db.find(where: { $0.editionId == id }, in: \.isbns).first ?? nil
  }

  func assign(client: inout DatabaseClient) {
    client.getEditionIsbn = { try await getIsbn($0) }
  }
}
