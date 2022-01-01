import Fluent
import FluentPostgresDriver
import Vapor

struct HandleEditionIds: AsyncMigration {

  func prepare(on database: Database) async throws {
    let sqlDb = database as! SQLDatabase

    try await createNonForeignKeyNullableColumns(database)

    if Env.get("SKIP_LEGACY_DATA_MIGRATION_STEPS") != "true" {
      try await addEditionIds(sqlDb)
    }

    try await removeColumns(database)
  }

  private func createNonForeignKeyNullableColumns(_ database: Database) async throws {
    try await database.schema(Download.M1.tableName)
      .field(Download.M10.editionId, .uuid)
      .update()
    try await database.schema(OrderItem.M3.tableName)
      .field(OrderItem.M10.editionId, .uuid)
      .update()
  }

  private func removeColumns(_ database: Database) async throws {
    try await database.schema(Download.M1.tableName)
      .deleteField(Download.M1.documentId)
      .deleteField(Download.M1.editionType)
      .update()
    try await database.schema(OrderItem.M3.tableName)
      .deleteField(OrderItem.M3.documentId)
      .deleteField(OrderItem.M3.editionType)
      .update()
  }

  private func addEditionIds(_ db: SQLDatabase) async throws {
    for (combined, uuidString) in editionIdMigrationMap {
      let parts = combined.split(separator: "/")
      let documentId = parts[0]
      let editionType = parts[1]

      let updateDownload = """
        UPDATE \(Download.M1.tableName)
        SET \(Download.M10.editionId) = '\(uuidString)'
        WHERE
          \"\(Download.M1.documentId)\" = '\(documentId)'
        AND
          \"\(Download.M1.editionType)\" = '\(editionType)'
        """
      _ = try await db.raw("\(raw: updateDownload)").all()

      let updateOrderItem = """
        UPDATE \(OrderItem.M3.tableName)
        SET \(OrderItem.M10.editionId) = '\(uuidString)'
        WHERE
          \"\(OrderItem.M3.documentId)\" = '\(documentId)'
        AND
          \"\(OrderItem.M3.editionType)\" = '\(editionType)'
        """
      _ = try await db.raw("\(raw: updateOrderItem)").all()
    }
  }

  func revert(on database: Database) async throws {
    // don't really care to try to reverse this one...
  }
}

// extensions

extension Download {
  enum M10 {
    static let editionId = FieldKey("edition_id")
  }
}

extension OrderItem {
  enum M10 {
    static let editionId = FieldKey("edition_id")
  }
}

// @TODO this will be replaced last minute with final export data
extension HandleEditionIds {
  var editionIdMigrationMap: [String: String] {
    [
      "a5a7cc71-bee0-4e71-80ae-e9167e140df4/modernized": "eac4eba0-48ff-4eee-a735-61cf7c56dee0",
      "a5a7cc71-bee0-4e71-80ae-e9167e140df4/original": "7a89ca74-a01f-4bf9-98fa-9137a0691280",
    ]
  }
}
