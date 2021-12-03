import Fluent
import Vapor

struct CreateFriends: Migration {

  func prepare(on database: Database) -> Future<Void> {
    let genderFuture = database.enum("gender")
      .case("male")
      .case("female")
      .case("mixed")
      .create()

    let langFuture = database.enum("lang").read()

    return genderFuture.and(langFuture).flatMap { enums -> Future<Void> in
      let (genders, langs) = enums
      return database.schema(Friend.M10.tableName)
        .id()
        .field(Friend.M10.lang, langs, .required)
        .field(Friend.M10.name, .string, .required)
        .field(Friend.M10.slug, .string, .required)
        .field(Friend.M10.gender, genders, .required)
        .field(Friend.M10.description, .string, .required)
        .field(Friend.M10.born, .int)
        .field(Friend.M10.died, .int, .required)
        .field(Friend.M10.isCompilations, .bool, .required)
        .field(Friend.M10.published, .datetime)
        .field(FieldKey.createdAt, .datetime, .required)
        .field(FieldKey.updatedAt, .datetime, .required)
        .unique(on: Friend.M10.lang, Friend.M10.name, Friend.M10.slug)
        .create()
    }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(Friend.M10.tableName).delete()
  }
}
