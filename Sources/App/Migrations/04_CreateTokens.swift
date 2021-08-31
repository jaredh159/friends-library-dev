import Fluent
import Vapor

struct CreateTokens: Migration {

  func prepare(on database: Database) -> Future<Void> {
    return database.schema("tokens")
      .id()
      .field("value", .uuid, .required)
      .field("description", .string, .required)
      .field("created_at", .datetime, .required)
      .unique(on: "value")
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema("tokens").delete()
  }
}
