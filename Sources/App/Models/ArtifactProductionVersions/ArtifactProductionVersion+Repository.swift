import FluentSQL
import Vapor

extension Repository where Model == ArtifactProductionVersion {
  func getLatest() async throws -> ArtifactProductionVersion {
    // @TODO implement ORDER BY and LIMIT
    try await findAll()
      .sorted { $0.createdAt > $1.createdAt }
      .firstOrThrowNotFound()
  }

  func assign(client: inout DatabaseClient) {
    client.getLatestArtifactProductionVersion = { try await getLatest() }
  }
}

extension MockRepository where Model == ArtifactProductionVersion {
  func getLatest() async throws -> ArtifactProductionVersion {
    try await findAll()
      .sorted { $0.createdAt > $1.createdAt }
      .firstOrThrowNotFound()
  }

  func assign(client: inout DatabaseClient) {
    client.getLatestArtifactProductionVersion = { try await getLatest() }
  }
}
