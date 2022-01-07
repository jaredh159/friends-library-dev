import Fluent
import FluentSQL

struct AddEditionIdForeignKeys: AsyncMigration {
  func prepare(on database: Database) async throws {
    let sql = database as! SQLDatabase

    _ = try await sql.raw(
      """
      ALTER TABLE \(raw: OrderItem.M3.tableName) 
      ADD CONSTRAINT \(raw: M26.orderItemsEditionIdForeignKey) 
      FOREIGN KEY (\(raw: OrderItem.M10.editionId.description)) 
      REFERENCES \(raw: Edition.M17.tableName) (\(raw: FieldKey.id.description))
      ON DELETE NO ACTION;
      """
    ).all()

    _ = try await sql.raw(
      """
      ALTER TABLE \(raw: Download.M1.tableName) 
      ADD CONSTRAINT \(raw: M26.downloadsEditionIdForeignKey) 
      FOREIGN KEY (\(raw: Download.M10.editionId.description)) 
      REFERENCES \(raw: Edition.M17.tableName) (\(raw: FieldKey.id.description))
      ON DELETE NO ACTION;
      """
    ).all()
  }

  func revert(on database: Database) async throws {
    let sql = database as! SQLDatabase

    _ = try await sql.raw(
      """
      ALTER TABLE \(raw: OrderItem.M3.tableName)
      DROP CONSTRAINT \(raw: M26.orderItemsEditionIdForeignKey);
      """
    ).all()

    _ = try await sql.raw(
      """
      ALTER TABLE \(raw: Download.M1.tableName)
      DROP CONSTRAINT \(raw: M26.downloadsEditionIdForeignKey);
      """
    ).all()
  }
}

extension AddEditionIdForeignKeys {
  enum M26 {
    static let orderItemsEditionIdForeignKey = "order_items_edition_id_fkey"
    static let downloadsEditionIdForeignKey = "downloads_edition_id_fkey"
  }
}
