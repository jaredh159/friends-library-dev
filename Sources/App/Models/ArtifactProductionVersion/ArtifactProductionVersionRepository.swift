import FluentSQL
import Vapor

struct ArtifactProductionVersionRepository {
  var db: SQLDatabase

  func create(_ model: ArtifactProductionVersion) throws -> Future<Void> {
    try insert(
      into: ArtifactProductionVersion.tableName,
      values: [
        ArtifactProductionVersion[.id]: .id(model),
        ArtifactProductionVersion[.version]: .string(model.version.rawValue),
        ArtifactProductionVersion[.createdAt]: .currentTimestamp,
      ]
    )
  }

  func getLatest() throws -> Future<ArtifactProductionVersion> {
    // @TODO implement ORDER BY and LIMIT
    try select(.all, from: ArtifactProductionVersion.self).flatMapThrowing { models in
      let models = models.sorted { $0.createdAt > $1.createdAt }
      guard let first = models.first else { throw DbError.notFound }
      return first
    }
  }
}

struct MockArtifactProductionVersionRepository {
  var db: MockDb
  var eventLoop: EventLoop

  func create(_ model: ArtifactProductionVersion) throws -> Future<Void> {
    future(db.add(model, to: \.artifactProductionVersions))
  }

  func getLatest() throws -> Future<ArtifactProductionVersion> {
    future(
      db.all(\.artifactProductionVersions)
        .sorted { $0.createdAt > $1.createdAt }
        .first!
    )
  }
}

/// extensions

extension ArtifactProductionVersionRepository: LiveRepository {
  func assign(client: inout DatabaseClient) {
    client.createArtifactProductionVersion = { try create($0) }
    client.getLatestArtifactProductionVersion = { try getLatest() }
  }
}

extension MockArtifactProductionVersionRepository: MockRepository {
  func assign(client: inout DatabaseClient) {
    client.createArtifactProductionVersion = { try create($0) }
    client.getLatestArtifactProductionVersion = { try getLatest() }
  }
}
