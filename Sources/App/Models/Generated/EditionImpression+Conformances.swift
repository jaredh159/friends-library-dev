// auto-generated, do not edit
import DuetSQL
import Tagged

extension EditionImpression: ApiModel {
  typealias Id = Tagged<EditionImpression, UUID>
}

extension EditionImpression: Model {
  static let tableName = M18.tableName
  static var isSoftDeletable: Bool { false }
}

extension EditionImpression {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case editionId
    case adocLength
    case paperbackSizeVariant
    case paperbackVolumes
    case publishedRevision
    case productionToolchainRevision
    case createdAt
  }
}

extension EditionImpression {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .editionId: .uuid(editionId),
      .adocLength: .int(adocLength),
      .paperbackSizeVariant: .enum(paperbackSizeVariant),
      .paperbackVolumes: .intArray(paperbackVolumes.array),
      .publishedRevision: .string(publishedRevision.rawValue),
      .productionToolchainRevision: .string(productionToolchainRevision.rawValue),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension EditionImpression: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<EditionImpression>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .editionId:
        return constraint.isSatisfiedBy(.uuid(editionId))
      case .adocLength:
        return constraint.isSatisfiedBy(.int(adocLength))
      case .paperbackSizeVariant:
        return constraint.isSatisfiedBy(.enum(paperbackSizeVariant))
      case .paperbackVolumes:
        return constraint.isSatisfiedBy(.intArray(paperbackVolumes.array))
      case .publishedRevision:
        return constraint.isSatisfiedBy(.string(publishedRevision.rawValue))
      case .productionToolchainRevision:
        return constraint.isSatisfiedBy(.string(productionToolchainRevision.rawValue))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension EditionImpression: Auditable {}
