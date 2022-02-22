// auto-generated, do not edit
import Foundation
import Tagged

extension EditionChapter: ApiModel {
  typealias Id = Tagged<EditionChapter, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .editionChapter(Self.self)
  }
}

extension EditionChapter: DuetModel {
  static let tableName = M22.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .editionId:
        return constraint.isSatisfiedBy(.uuid(editionId))
      case .order:
        return constraint.isSatisfiedBy(.int(order))
      case .shortHeading:
        return constraint.isSatisfiedBy(.string(shortHeading))
      case .isIntermediateTitle:
        return constraint.isSatisfiedBy(.bool(isIntermediateTitle))
      case .customId:
        return constraint.isSatisfiedBy(.string(customId))
      case .sequenceNumber:
        return constraint.isSatisfiedBy(.int(sequenceNumber))
      case .nonSequenceTitle:
        return constraint.isSatisfiedBy(.string(nonSequenceTitle))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension EditionChapter: Auditable {}
extension EditionChapter: Touchable {}
