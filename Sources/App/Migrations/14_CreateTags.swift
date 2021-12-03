import Fluent

struct CreateTags: Migration {
  private typealias M14 = DocumentTagModel.M14

  func prepare(on database: Database) -> Future<Void> {
    database.enum(M14.DocumentTagEnum.name)
      .case(M14.DocumentTagEnum.caseJournal)
      .case(M14.DocumentTagEnum.caseLetters)
      .case(M14.DocumentTagEnum.caseExhortation)
      .case(M14.DocumentTagEnum.caseDoctrinal)
      .case(M14.DocumentTagEnum.caseTreatise)
      .case(M14.DocumentTagEnum.caseHistory)
      .case(M14.DocumentTagEnum.caseAllegory)
      .case(M14.DocumentTagEnum.caseSpiritualLife)
      .create()
      .flatMap { tags in
        database.schema(M14.tableName)
          .id()
          .field(M14.slug, tags, .required)
          .field(.createdAt, .datetime, .required)
          .unique(on: M14.slug)
          .create()
      }.flatMap {
        DocumentTag.allCases.map { DocumentTagModel(slug: $0) }
          .create(on: database)
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M14.tableName).delete()
  }
}
