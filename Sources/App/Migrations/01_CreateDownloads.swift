import Fluent

struct CreateAdminUsers: Migration {
  func prepare(on database: Database) -> Future<Void> {
    return database.schema("create_downloads")
      .id()
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema("create_downloads").delete()
  }
}
