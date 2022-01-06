// auto-generated, do not edit
import Foundation
import Tagged

extension EditionImpression: AppModel {
  typealias Id = Tagged<EditionImpression, UUID>
}

extension EditionImpression: DuetModel {
  static let tableName = M18.tableName
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

extension EditionImpression: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "edition_id":
        return .uuid(editionId) == constraint.value
      case "adoc_length":
        return .int(adocLength) == constraint.value
      case "paperback_size":
        return .enum(paperbackSize) == constraint.value
      case "paperback_volumes":
        return .intArray(paperbackVolumes.array) == constraint.value
      case "published_revision":
        return .string(publishedRevision.rawValue) == constraint.value
      case "production_toolchain_revision":
        return .string(productionToolchainRevision.rawValue) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension EditionImpression: Auditable {}
