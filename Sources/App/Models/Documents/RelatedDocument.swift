import Foundation

final class RelatedDocument: Codable {
  var id: Id
  var description: String
  var documentId: Document.Id
  var parentDocumentId: Document.Id
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var document = Parent<Document>.notLoaded
  var parentDocument = Parent<Document>.notLoaded

  init(
    id: Id = .init(),
    description: String,
    documentId: Document.Id,
    parentDocumentId: Document.Id
  ) {
    self.id = id
    self.description = description
    self.documentId = documentId
    self.parentDocumentId = parentDocumentId
  }
}
