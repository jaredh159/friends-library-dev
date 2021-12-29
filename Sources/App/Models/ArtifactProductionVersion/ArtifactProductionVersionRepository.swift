import FluentSQL
import Vapor

struct ArtifactProductionVersionRepository {
  var db: SQLDatabase

  func getLatest() async throws -> ArtifactProductionVersion {
    // @TODO implement ORDER BY and LIMIT
    let models = try await select().sorted { $0.createdAt > $1.createdAt }
    guard let first = models.first else { throw DbError.notFound }
    return first
  }
}

struct MockArtifactProductionVersionRepository {
  var db: MockDb

  func create(_ model: ArtifactProductionVersion) async throws {
    db.add(model, to: \.artifactProductionVersions)
  }

  func getLatest() async throws -> ArtifactProductionVersion {
    db.all(\.artifactProductionVersions)
      .sorted { $0.createdAt > $1.createdAt }
      .first!
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

  func assign(client: inout DatabaseClient) {
    client.createArtifactProductionVersion = { try await create($0) }
    client.getLatestArtifactProductionVersion = { try await getLatest() }
  }
}
