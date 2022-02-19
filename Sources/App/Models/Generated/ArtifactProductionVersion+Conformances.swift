// auto-generated, do not edit
import Foundation
import Tagged

extension ArtifactProductionVersion: ApiModel {
  typealias Id = Tagged<ArtifactProductionVersion, UUID>
}

extension ArtifactProductionVersion: DuetModel {
  static let tableName = M8.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .version:
        return constraint.isSatisfiedBy(.string(version.rawValue))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension ArtifactProductionVersion: Auditable {}
