import Fluent
import Tagged
import Vapor

final class ArtifactProductionVersion {
  var id: Id
  var version: GitCommitSha
  var createdAt = Current.date()

  init(id: Id = .init(), version: GitCommitSha) {
    self.id = id
    self.version = version
  }
}

// extensions

extension ArtifactProductionVersion: AppModel {
  typealias Id = Tagged<ArtifactProductionVersion, UUID>
}

extension ArtifactProductionVersion: DuetModel {
  static let tableName = M8.tableName
}

extension ArtifactProductionVersion: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case version
    case createdAt
  }
}

extension ArtifactProductionVersion {
  enum M8 {
    static let tableName = "artifact_production_versions"
    static let version = FieldKey("version")
  }
}
