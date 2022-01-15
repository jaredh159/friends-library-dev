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

extension EditionChapter {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .editionId: .uuid(editionId),
      .order: .int(order),
      .shortHeading: .string(shortHeading),
      .isIntermediateTitle: .bool(isIntermediateTitle),
      .customId: .string(customId),
      .sequenceNumber: .int(sequenceNumber),
      .nonSequenceTitle: .string(nonSequenceTitle),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension EditionChapter: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "edition_id":
        return .uuid(editionId) == constraint.value
      case "order":
        return .int(order) == constraint.value
      case "short_heading":
        return .string(shortHeading) == constraint.value
      case "is_intermediate_title":
        return .bool(isIntermediateTitle) == constraint.value
      case "custom_id":
        return .string(customId) == constraint.value
      case "sequence_number":
        return .int(sequenceNumber) == constraint.value
      case "non_sequence_title":
        return .string(nonSequenceTitle) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension EditionChapter: Auditable {}
extension EditionChapter: Touchable {}
