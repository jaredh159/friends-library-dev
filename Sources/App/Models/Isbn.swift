import Fluent
import Foundation
import Tagged

final class Isbn {
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

extension Isbn: AppModel {
  typealias Id = Tagged<Isbn, UUID>
}

extension Isbn: DuetModel {
  static let tableName = M18.tableName
}

extension Isbn: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case code
    case editionId
    case createdAt
    case updatedAt
  }
}

extension Isbn {
  enum M18 {
    static let tableName = "isbns"
    static let code = FieldKey("code")
    static let editionId = FieldKey("edition_id")
  }
}
