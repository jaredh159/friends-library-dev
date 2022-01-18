// auto-generated, do not edit
import Foundation
import Tagged

extension ArtifactProductionVersion: ApiModel {
  typealias Id = Tagged<ArtifactProductionVersion, UUID>
}

extension ArtifactProductionVersion: DuetModel {
  static let tableName = M8.tableName
}

extension ArtifactProductionVersion {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case version
    case createdAt
  }
}

extension ArtifactProductionVersion {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .version: .string(version.rawValue),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension ArtifactProductionVersion: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<ArtifactProductionVersion>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .version:
        return .string(version.rawValue) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
    }
  }
}

extension ArtifactProductionVersion: Auditable {}
