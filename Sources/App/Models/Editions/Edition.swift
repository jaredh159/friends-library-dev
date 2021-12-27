import Fluent
import Foundation
import NonEmpty
import Tagged
import Vapor

final class Edition: Codable {
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
