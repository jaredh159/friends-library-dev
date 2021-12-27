import Fluent

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

extension DocumentTag: PostgresEnum {
  var dataType: String {
    DocumentTagModel.M14.DocumentTagEnum.name
  }
}
