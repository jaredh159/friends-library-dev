import Fluent
import Vapor

struct AddTokenUses: AsyncMigration {

  func prepare(on database: Database) async throws {
    try await database.schema(Token.M4.tableName)
      .field(Token.M27.uses, .int)
      .update()
  }

  func revert(on database: Database) async throws {
    try await database.schema(Token.M4.tableName)
      .field(Token.M27.uses, .int)
      .delete()
  }
}

extension Token {
  enum M27 {
    static let uses = FieldKey("uses")
  }
}
