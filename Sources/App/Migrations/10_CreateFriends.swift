import Fluent
import Vapor

struct CreateFriends: Migration {
  private typealias M10 = Friend.M10

  func prepare(on database: Database) -> Future<Void> {
    let genderFuture = database.enum(M10.GenderEnum.name)
      .case(M10.GenderEnum.caseMale)
      .case(M10.GenderEnum.caseFemale)
      .case(M10.GenderEnum.caseMixed)
      .create()

    let langFuture = database.enum("lang").read()

    return genderFuture.and(langFuture).flatMap { enums -> Future<Void> in
      let (genders, langs) = enums
      return database.schema(M10.tableName)
        .id()
        .field(M10.lang, langs, .required)
        .field(M10.name, .string, .required)
        .field(M10.slug, .string, .required)
        .field(M10.gender, genders, .required)
        .field(M10.description, .string, .required)
        .field(M10.born, .int)
        .field(M10.died, .int)
        .field(M10.published, .datetime)
        .field(.createdAt, .datetime, .required)
        .field(.updatedAt, .datetime, .required)
        .unique(on: M10.lang, M10.slug)
        .create()
    }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M10.tableName).delete()
  }
}
