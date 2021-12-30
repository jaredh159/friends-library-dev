// auto-generated, do not edit
import Foundation
import Tagged

extension EditionImpression: AppModel {
  typealias Id = Tagged<EditionImpression, UUID>
}

extension EditionImpression: DuetModel {
  static let tableName = M17.tableName
}

extension EditionImpression {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.editionId]: .uuid(editionId),
      Self[.adocLength]: .int(adocLength),
      Self[.paperbackSize]: .enum(paperbackSize),
      Self[.paperbackVolumes]: .intArray(paperbackVolumes.array),
      Self[.publishedRevision]: .string(publishedRevision.rawValue),
      Self[.productionToolchainRevision]: .string(productionToolchainRevision.rawValue),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension EditionImpression {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
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

extension EditionImpression: Auditable {}
