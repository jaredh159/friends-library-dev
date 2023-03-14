import Fluent
import Vapor

struct AddOrderFeesColumn: AsyncMigration {

  func prepare(on database: Database) async throws {
    Current.logger.info("Running migration: AddOrderFeesColumn UP")
    try await database.schema(Order.M2.tableName)
      .field(Order.M28.fees, .int, .sql(.default(0)))
      .update()
  }

  func revert(on database: Database) async throws {
    Current.logger.info("Running migration: AddOrderFeesColumn DOWN")
    try await database.schema(Order.M2.tableName)
      .field(Order.M28.fees, .int, .sql(.default(0)))
      .delete()
  }
}

extension Order {
  enum M28 {
    static let fees = FieldKey("fees")
  }
}
