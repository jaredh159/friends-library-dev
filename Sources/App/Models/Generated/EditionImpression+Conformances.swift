// auto-generated, do not edit
import DuetSQL
import Tagged

extension EditionImpression: ApiModel {
  typealias Id = Tagged<EditionImpression, UUID>
}

extension EditionImpression: Model {
  static let tableName = M18.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .editionId:
        return .uuid(editionId)
      case .adocLength:
        return .int(adocLength)
      case .paperbackSizeVariant:
        return .enum(paperbackSizeVariant)
      case .paperbackVolumes:
        return .intArray(paperbackVolumes.array)
      case .publishedRevision:
        return .string(publishedRevision.rawValue)
      case .productionToolchainRevision:
        return .string(productionToolchainRevision.rawValue)
      case .createdAt:
        return .date(createdAt)
    }
  }
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
