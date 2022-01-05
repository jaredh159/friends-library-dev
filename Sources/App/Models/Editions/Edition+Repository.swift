import FluentSQL
import Vapor

extension Repository where Model == Edition {
  func getIsbn(_ id: Edition.Id) async throws -> Isbn? {
    try await findOptionalChild(id, fk: Isbn[.editionId])
  }

  func getAudio(_ id: Edition.Id) async throws -> Audio? {
    try await findOptionalChild(id, fk: Audio[.editionId])
  }

  func getImpression(_ id: Edition.Id) async throws -> EditionImpression? {
    try await findOptionalChild(id, fk: EditionImpression[.editionId])
  }

  func getChapters(_ id: Edition.Id) async throws -> [EditionChapter] {
    try await findChildren(id, fk: EditionChapter[.editionId])
  }

  func assign(client: inout DatabaseClient) {
    client.getEditionIsbn = { try await getIsbn($0) }
    client.getEditionAudio = { try await getAudio($0) }
    client.getEditionEditionImpression = { try await getImpression($0) }
    client.getEditionEditionChapters = { try await getChapters($0) }
  }
}

extension MockRepository where Model == Edition {
  func getIsbn(_ id: Edition.Id) async throws -> Isbn? {
    db.find(where: { $0.editionId == id }, in: \.isbns).first ?? nil
  }

  func getAudio(_ id: Edition.Id) async throws -> Audio? {
    db.find(where: { $0.editionId == id }, in: \.audios).first ?? nil
  }

  func getImpression(_ id: Edition.Id) async throws -> EditionImpression? {
    db.find(where: { $0.editionId == id }, in: \.editionImpressions).first ?? nil
  }

  func getChapters(_ id: Edition.Id) async throws -> [EditionChapter] {
    db.find(where: { $0.editionId == id }, in: \.editionChapters)
  }

  func assign(client: inout DatabaseClient) {
    client.getEditionIsbn = { try await getIsbn($0) }
    client.getEditionAudio = { try await getAudio($0) }
    client.getEditionEditionImpression = { try await getImpression($0) }
    client.getEditionEditionChapters = { try await getChapters($0) }
  }
}
