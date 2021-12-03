import Fluent
import Vapor

enum DocumentTag: String, Codable, CaseIterable {
  case journal
  case letters
  case exhortation
  case doctrinal
  case treatise
  case history
  case allegory
  case spiritualLife
}

final class DocumentTagModel: Model, Content {
  static let schema = M14.tableName

  @ID(key: .id)
  var id: UUID?

  @Enum(key: M14.slug)
  var slug: DocumentTag

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  init() {}

  init(slug: DocumentTag) {
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
