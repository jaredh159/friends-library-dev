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

  enum CodingKeys: String, CodingKey, CaseIterable {
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
  func satisfies(constraint: SQL.WhereConstraint<EditionChapter>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .editionId:
        return .uuid(editionId) == constraint.value
      case .order:
        return .int(order) == constraint.value
      case .shortHeading:
        return .string(shortHeading) == constraint.value
      case .isIntermediateTitle:
        return .bool(isIntermediateTitle) == constraint.value
      case .customId:
        return .string(customId) == constraint.value
      case .sequenceNumber:
        return .int(sequenceNumber) == constraint.value
      case .nonSequenceTitle:
        return .string(nonSequenceTitle) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension EditionChapter: Auditable {}
extension EditionChapter: Touchable {}
