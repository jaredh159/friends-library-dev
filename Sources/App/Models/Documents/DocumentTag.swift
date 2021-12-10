import Fluent
import Foundation
import Vapor

final class DocumentTagModel: Model, Content {
  static let schema = M14.tableName

  @ID(key: .id)
  var id: UUID?

  @Enum(key: M14.slug)
  var slug: DocumentTag

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  init() {}

  init(id: UUID? = nil, slug: DocumentTag) {
    self.id = id
    self.slug = slug
  }
}

extension DocumentTagModel {
  enum M14 {
    static let tableName = "document_tags"
    static let slug = FieldKey("slug")
    enum DocumentTagEnum {
      static let name = "document_tags_enum"
      static let caseJournal = "journal"
      static let caseLetters = "letters"
      static let caseExhortation = "exhortation"
      static let caseDoctrinal = "doctrinal"
      static let caseTreatise = "treatise"
      static let caseHistory = "history"
      static let caseAllegory = "allegory"
      static let caseSpiritualLife = "spiritualLife"
    }
  }
}
