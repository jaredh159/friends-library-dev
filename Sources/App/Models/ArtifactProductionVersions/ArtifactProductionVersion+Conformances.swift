// auto-generated, do not edit
import Foundation
import Tagged

extension ArtifactProductionVersion: AppModel {
  typealias Id = Tagged<ArtifactProductionVersion, UUID>
}

extension ArtifactProductionVersion: DuetModel {
  static let tableName = M8.tableName
}

extension ArtifactProductionVersion {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.version]: .string(version.rawValue),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension ArtifactProductionVersion {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case version
    case createdAt
  }
}

extension ArtifactProductionVersion: Auditable {}
