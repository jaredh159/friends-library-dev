import Fluent
import Tagged
import Vapor

final class ArtifactProductionVersion: Codable {
  var id: Id
  var version: GitCommitSha
  var createdAt = Current.date()

  init(id: Id = .init(), version: GitCommitSha) {
    self.id = id
    self.version = version
  }
}

// extensions

extension ArtifactProductionVersion {
  enum M8 {
    static let tableName = "artifact_production_versions"
    static let version = FieldKey("version")
  }
}
