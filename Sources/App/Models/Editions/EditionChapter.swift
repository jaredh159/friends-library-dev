import Fluent
import Foundation
import Tagged

final class EditionChapter {
  var id: Id
  var editionId: Edition.Id
  var order: Int
  var shortHeading: String
  var isIntermediateTitle: Bool
  var customId: String?
  var sequenceNumber: Int?
  var nonSequenceTitle: String?
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var edition = Parent<Edition>.notLoaded

  init(
    id: Id = .init(),
    editionId: Edition.Id,
    order: Int,
    shortHeading: String,
    isIntermediateTitle: Bool,
    customId: String? = nil,
    sequenceNumber: Int? = nil,
    nonSequenceTitle: String? = nil
  ) {
    self.id = id
    self.editionId = editionId
    self.order = order
    self.shortHeading = shortHeading
    self.isIntermediateTitle = isIntermediateTitle
    self.customId = customId
    self.sequenceNumber = sequenceNumber
    self.nonSequenceTitle = nonSequenceTitle
  }
}

// extensions

extension EditionChapter: AppModel {
  typealias Id = Tagged<EditionChapter, UUID>
}

extension EditionChapter: DuetModel {
  static let tableName = M21.tableName
}

extension EditionChapter: Codable {
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
  enum M21 {
    static let tableName = "edition_chapters"
    static let editionId = FieldKey("edition_id")
    static let order = FieldKey("order")
    static let customId = FieldKey("custom_id")
    static let shortHeading = FieldKey("short_heading")
    static let isIntermediateTitle = FieldKey("is_intermediate_title")
    static let sequenceNumber = FieldKey("sequence_number")
    static let nonSequenceTitle = FieldKey("non_sequence_title")
  }
}
