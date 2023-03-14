// auto-generated, do not edit
import DuetSQL
import Tagged

extension EditionChapter: ApiModel {
  typealias Id = Tagged<EditionChapter, UUID>
}

extension EditionChapter: Model {
  static let tableName = M22.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .editionId:
        return .uuid(editionId)
      case .order:
        return .int(order)
      case .shortHeading:
        return .string(shortHeading)
      case .isIntermediateTitle:
        return .bool(isIntermediateTitle)
      case .customId:
        return .string(customId)
      case .sequenceNumber:
        return .int(sequenceNumber)
      case .nonSequenceTitle:
        return .string(nonSequenceTitle)
      case .createdAt:
        return .date(createdAt)
      case .updatedAt:
        return .date(updatedAt)
    }
  }
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
