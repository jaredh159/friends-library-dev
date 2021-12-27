import Fluent

extension Isbn {
  enum M18 {
    static let tableName = "isbns"
    static let code = FieldKey("code")
    static let editionId = FieldKey("edition_id")
  }
}
