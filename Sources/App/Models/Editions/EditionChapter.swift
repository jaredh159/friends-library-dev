import Fluent
import Foundation
import Vapor

final class EditionChapter: Model, Content {
  static let schema = M21.tableName

  @ID(key: .id)
  var id: UUID?

  // @Parent(key: M21.editionId)
  // var edition: Edition

  @Field(key: M21.order)
  var order: Int

  @OptionalField(key: M21.customId)
  var customId: String?

  @Field(key: M21.shortHeading)
  var shortHeading: String

  @Field(key: M21.isIntermediateTitle)
  var isIntermediateTitle: Bool

  @OptionalField(key: M21.sequenceNumber)
  var sequenceNumber: Int?

  @OptionalField(key: M21.nonSequenceTitle)
  var nonSequenceTitle: String?

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?
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
