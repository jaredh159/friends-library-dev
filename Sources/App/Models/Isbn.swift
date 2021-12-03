import Fluent
import Foundation
import Vapor

final class Isbn: Model, Content {
  static let schema = M18.tableName

  @ID(key: .id)
  var id: UUID?

  @Field(key: M18.code)
  var code: ISBN

  @OptionalParent(key: M18.editionId)
  var edition: Edition?

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?
}

extension Isbn {
  enum M18 {
    static let tableName = "isbns"
    static let code = FieldKey("code")
    static let editionId = FieldKey("edition_id")
  }
}
