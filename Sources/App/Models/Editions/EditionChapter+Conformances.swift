// auto-generated, do not edit
import Foundation
import Tagged

extension EditionChapter: AppModel {
  typealias Id = Tagged<EditionChapter, UUID>
}

extension EditionChapter: DuetModel {
  static let tableName = M21.tableName
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

extension EditionChapter: Auditable {}
extension EditionChapter: Touchable {}
