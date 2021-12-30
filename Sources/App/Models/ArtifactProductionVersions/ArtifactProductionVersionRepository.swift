import FluentSQL
import Vapor

struct ArtifactProductionVersionRepository {
  var db: SQLDatabase

  func getLatest() async throws -> ArtifactProductionVersion {
    // @TODO implement ORDER BY and LIMIT
    try await select()
      .sorted { $0.createdAt > $1.createdAt }
      .firstOrThrowNotFound()
  }
}

struct MockArtifactProductionVersionRepository {
  var db: MockDb

  func getLatest() async throws -> ArtifactProductionVersion {
    try await select()
      .sorted { $0.createdAt > $1.createdAt }
      .firstOrThrowNotFound()
  }
}

/// extensions

extension ArtifactProductionVersionRepository: LiveRepository {
  typealias Model = ArtifactProductionVersion

  func assign(client: inout DatabaseClient) {
    client.createArtifactProductionVersion = { try await create($0) }
    client.getLatestArtifactProductionVersion = { try await getLatest() }
  }
}

extension MockArtifactProductionVersionRepository: MockRepository {
  typealias Model = ArtifactProductionVersion
  var models: ModelsPath { \.artifactProductionVersions }

  func assign(client: inout DatabaseClient) {
    client.createArtifactProductionVersion = { try await create($0) }
    client.getLatestArtifactProductionVersion = { try await getLatest() }
  }
}
