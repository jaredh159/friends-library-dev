import Fluent

struct CreateEditions: Migration {
  private typealias M16 = Edition.M16

  func prepare(on database: Database) -> Future<Void> {
    database.enum(M16.PrintSizeVariantEnum.name)
      .case(M16.PrintSizeVariantEnum.caseS)
      .case(M16.PrintSizeVariantEnum.caseM)
      .case(M16.PrintSizeVariantEnum.caseXl)
      .case(M16.PrintSizeVariantEnum.caseXlCondensed)
      .create()
      .flatMap { printSizeVariants in
        database.enum(Download.M1.EditionTypeEnum.name)
          .read()
          .map { editionTypes in (editionTypes, printSizeVariants) }
      }.flatMap { (editionTypes, printSizeVariants) in
        database.schema(M16.tableName)
          .id()
          .field(
            Edition.M16.documentId,
            .uuid,
            .references(Document.M13.tableName, .id, onDelete: .cascade),
            .required
          )
          .field(M16.type, editionTypes, .required)
          .field(M16.editor, .string)
          .field(M16.isDraft, .bool, .required)
          .field(M16.paperbackOverrideSize, printSizeVariants)
          .field(.createdAt, .datetime, .required)
          .field(.updatedAt, .datetime, .required)
          .field(.deletedAt, .datetime, .required)
          .unique(on: M16.documentId, M16.type)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(M16.tableName).delete()
      .flatMap {
        database.enum(M16.PrintSizeVariantEnum.name).delete()
      }
  }
}
