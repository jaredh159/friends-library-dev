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
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case version
    case createdAt
  }
}

extension ArtifactProductionVersion: Auditable {}
