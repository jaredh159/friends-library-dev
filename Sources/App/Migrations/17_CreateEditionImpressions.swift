import Fluent

struct CreateEditionImpressions: Migration {
  private typealias M17 = EditionImpression.M17

  func prepare(on database: Database) -> Future<Void> {
    database.enum(Edition.M16.PrintSizeVariantEnum.name)
      .read()
      .flatMap { printSizeVariants in
        database.schema(M17.tableName)
          .id()
          .field(
            M17.editionId,
            .uuid,
            .references(Edition.M16.tableName, .id, onDelete: .cascade),
            .required
          )
          .field(M17.adocLength, .int, .required)
          .field(M17.paperbackSize, printSizeVariants, .required)
          .field(M17.paperbackSplits, .array(of: .int), .required)
          .field(M17.paperbackVolumes, .array(of: .int), .required)
          .field(M17.publishedRevision, .string, .required)
          .field(M17.productionToolchainRevision, .string, .required)
          .field(.createdAt, .datetime, .required)
          .field(.updatedAt, .datetime, .required)
          .unique(on: M17.editionId)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M17.tableName).delete()
  }
}
