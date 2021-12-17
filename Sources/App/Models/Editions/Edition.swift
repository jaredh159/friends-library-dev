import Fluent
import Foundation
import NonEmpty
import Tagged
import Vapor

final class Edition {
  var id: Id
  var documentId: Document.Id
  var type: EditionType
  var editor: String?
  var isDraft: Bool
  var paperbackSplits: NonEmpty<[Int]>?
  var paperbackOverrideSize: PrintSizeVariant?
  var createdAt = Current.date()
  var updatedAt = Current.date()
  var deletedAt: Date? = nil

  var document = Parent<Document>.notLoaded

  init(
    id: Id = .init(),
    documentId: Document.Id,
    type: EditionType,
    editor: String?,
    isDraft: Bool = false,
    paperbackSplits: NonEmpty<[Int]>? = nil,
    paperbackOverrideSize: PrintSizeVariant? = nil
  ) {
    self.id = id
    self.documentId = documentId
    self.type = type
    self.editor = editor
    self.isDraft = isDraft
    self.paperbackSplits = paperbackSplits
    self.paperbackOverrideSize = paperbackOverrideSize
  }

  // @OptionalChild(for: \EditionImpression.$edition)
  // var impression: EditionImpression?

  // @OptionalChild(for: \Isbn.$edition)
  // var isbn: Isbn?
}

// extensions

extension Edition: AppModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: DuetModel {
  static let tableName = M16.tableName
}

extension Edition: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case documentId
    case type
    case editor
    case isDraft
    case paperbackSplits
    case paperbackOverrideSize
    case createdAt
    case updatedAt
    case deletedAt

  }
}

extension Edition {
  enum M16 {
    static let tableName = "editions"
    static let documentId = FieldKey("document_id")
    static let type = FieldKey("type")
    static let editor = FieldKey("editor")
    static let isDraft = FieldKey("is_draft")
    static let paperbackOverrideSize = FieldKey("paperback_override_size")
    static let paperbackSplits = FieldKey("paperback_splits")
    enum PrintSizeVariantEnum {
      static let name = "print_size_variants"
      static let caseS = "s"
      static let caseM = "m"
      static let caseXl = "xl"
      static let caseXlCondensed = "xl--condensed"
    }
  }
}
