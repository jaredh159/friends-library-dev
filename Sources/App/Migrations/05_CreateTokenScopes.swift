import Fluent
import Vapor

struct CreateTokenScopes: Migration {

  func prepare(on database: Database) -> Future<Void> {
    return database.enum("scopes")
      .case("queryDownloads")
      .case("mutateDownloads")
      .case("queryOrders")
      .case("mutateOrders")
      .create()
      .flatMap { scopes in
        database.schema("token_scopes")
          .id()
          .field(
            "token_id",
            .uuid,
            .required,
            .references("tokens", "id", onDelete: .cascade)
          )
          .field("scope", scopes, .required)
          .field("created_at", .datetime, .required)
          .unique(on: "token_id", "scope")
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema("token_scopes").delete()
  }
}
