// auto-generated, do not edit
import Foundation
import Tagged

extension EditionChapter: AppModel {
  typealias Id = Tagged<EditionChapter, UUID>
}

extension EditionChapter: DuetModel {
  static let tableName = M22.tableName
}

extension EditionChapter {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.editionId]: .uuid(editionId),
      Self[.order]: .int(order),
      Self[.shortHeading]: .string(shortHeading),
      Self[.isIntermediateTitle]: .bool(isIntermediateTitle),
      Self[.customId]: .string(customId),
      Self[.sequenceNumber]: .int(sequenceNumber),
      Self[.nonSequenceTitle]: .string(nonSequenceTitle),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension EditionChapter {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case editionId
    case order
    case shortHeading
    case isIntermediateTitle
    case customId
    case sequenceNumber
    case nonSequenceTitle
    case createdAt
    case updatedAt
  }
}

extension EditionChapter: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "editionId":
        return .uuid(editionId) == constraint.value
      case "order":
        return .int(order) == constraint.value
      case "shortHeading":
        return .string(shortHeading) == constraint.value
      case "isIntermediateTitle":
        return .bool(isIntermediateTitle) == constraint.value
      case "customId":
        return .string(customId) == constraint.value
      case "sequenceNumber":
        return .int(sequenceNumber) == constraint.value
      case "nonSequenceTitle":
        return .string(nonSequenceTitle) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      case "updatedAt":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension EditionChapter: Auditable {}
extension EditionChapter: Touchable {}
