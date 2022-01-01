import Fluent

struct CreateEditions: Migration {
  private typealias M17 = Edition.M17

  func prepare(on database: Database) -> Future<Void> {
    database.enum(M17.PrintSizeVariantEnum.name)
      .case(M17.PrintSizeVariantEnum.caseS)
      .case(M17.PrintSizeVariantEnum.caseM)
      .case(M17.PrintSizeVariantEnum.caseXl)
      .case(M17.PrintSizeVariantEnum.caseXlCondensed)
      .create()
      .flatMap { printSizeVariants in
        database.enum(Download.M1.EditionTypeEnum.name)
          .read()
          .map { editionTypes in (editionTypes, printSizeVariants) }
      }.flatMap { (editionTypes, printSizeVariants) in
        database.schema(M17.tableName)
          .id()
          .field(
            Edition.M17.documentId,
            .uuid,
            .references(Document.M14.tableName, .id, onDelete: .cascade),
            .required
          )
          .field(M17.type, editionTypes, .required)
          .field(M17.editor, .string)
          .field(M17.isDraft, .bool, .required)
          .field(M17.paperbackSplits, .array(of: .int))
          .field(M17.paperbackOverrideSize, printSizeVariants)
          .field(.createdAt, .datetime, .required)
          .field(.updatedAt, .datetime, .required)
          .field(.deletedAt, .datetime)
          .unique(on: M17.documentId, M17.type)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M17.tableName).delete()
      .flatMap {
        database.enum(M17.PrintSizeVariantEnum.name).delete()
      }
  }
}
