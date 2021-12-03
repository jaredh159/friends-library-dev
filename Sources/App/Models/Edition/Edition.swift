import Fluent
import Foundation
import Vapor

final class Edition: Model, Content {
  static let schema = M16.tableName

  @ID(key: .id)
  var id: UUID?

  @OptionalChild(for: \EditionImpression.$edition)
  var impression: EditionImpression?

  @OptionalChild(for: \Isbn.$edition)
  var isbn: Isbn?

  @Parent(key: M16.documentId)
  var document: Document

  @Enum(key: M16.type)
  var type: EditionType

  @OptionalField(key: M16.editor)
  var editor: String?

  @Field(key: M16.isDraft)
  var isDraft: Bool

  @OptionalEnum(key: M16.paperbackOverrideSize)
  var paperbackOverrideSize: PrintSizeVariant?

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?

  @Timestamp(key: .deletedAt, on: .delete)
  var deletedAt: Date?
}

extension Edition {
  enum M16 {
    static let tableName = "editions"
    static let documentId = FieldKey("document_id")
    static let type = FieldKey("type")
    static let editor = FieldKey("editor")
    static let isDraft = FieldKey("is_draft")
    static let paperbackOverrideSize = FieldKey("paperback_override_size")
    enum PrintSizeVariantEnum {
      static let name = "print_size_variants"
      static let caseS = "s"
      static let caseM = "m"
      static let caseXl = "xl"
      static let caseXlCondensed = "xl--condensed"
    }
  }
}
