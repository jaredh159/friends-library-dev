import Fluent

struct CreateEditionImpressions: Migration {
  private typealias M18 = EditionImpression.M18

  func prepare(on database: Database) -> Future<Void> {
    Current.logger.info("Running migration: CreateEditionImpressions UP")
    return database.enum(Edition.M17.PrintSizeVariantEnum.name)
      .read()
      .flatMap { printSizeVariants in
        database.schema(M18.tableName)
          .id()
          .field(
            M18.editionId,
            .uuid,
            .references(Edition.M17.tableName, .id, onDelete: .cascade),
            .required
          )
          .field(M18.adocLength, .int, .required)
          .field(M18.paperbackSize, printSizeVariants, .required)
          .field(M18.paperbackVolumes, .array(of: .int), .required)
          .field(M18.publishedRevision, .string, .required)
          .field(M18.productionToolchainRevision, .string, .required)
          .field(.createdAt, .datetime, .required)
          .unique(on: M18.editionId)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    Current.logger.info("Running migration: CreateEditionImpressions DOWN")
    return database.schema(M18.tableName).delete()
  }
}
