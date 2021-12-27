import Fluent

extension Download {
  enum M1 {
    static let tableName = "downloads"
    enum EditionTypeEnum {
      static let name = "edition_type"
      static let caseUpdated = "updated"
      static let caseModernized = "modernized"
      static let caseOriginal = "original"
    }
  }
}
