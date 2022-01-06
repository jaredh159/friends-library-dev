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

extension ArtifactProductionVersion: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "version":
        return .string(version.rawValue) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension ArtifactProductionVersion: Auditable {}
