// auto-generated, do not edit
import Foundation
import Tagged

extension EditionImpression: ApiModel {
  typealias Id = Tagged<EditionImpression, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .editionImpression(Self.self)
  }
}

extension EditionImpression: DuetModel {
  static let tableName = M18.tableName
}

extension EditionImpression {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case editionId
    case adocLength
    case paperbackSize
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
      .paperbackSize: .enum(paperbackSize),
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
        return .id(self) == constraint.value
      case .editionId:
        return .uuid(editionId) == constraint.value
      case .adocLength:
        return .int(adocLength) == constraint.value
      case .paperbackSize:
        return .enum(paperbackSize) == constraint.value
      case .paperbackVolumes:
        return .intArray(paperbackVolumes.array) == constraint.value
      case .publishedRevision:
        return .string(publishedRevision.rawValue) == constraint.value
      case .productionToolchainRevision:
        return .string(productionToolchainRevision.rawValue) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
    }
  }
}

extension EditionImpression: Auditable {}
