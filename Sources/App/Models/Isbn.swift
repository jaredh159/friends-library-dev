import Fluent
import Foundation
import Tagged

final class Isbn: Codable {
  var id: Id
  var code: ISBN
  var editionId: Edition.Id?
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var edition = OptionalParent<Edition>.notLoaded

  init(
    id: Id = .init(),
    code: ISBN,
    editionId: Edition.Id?
  ) {
    self.id = id
    self.code = code
    self.editionId = editionId
  }
}

// extensions

extension Isbn {
  enum M18 {
    static let tableName = "isbns"
    static let code = FieldKey("code")
    static let editionId = FieldKey("edition_id")
  }
}
