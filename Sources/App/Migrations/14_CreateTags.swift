import Fluent
import Foundation

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
        // }.flatMap {
        //   DocumentTag.allCases.map { tag in DocumentTagModel(id: .init(rawValue: tag.id), slug: tag) }
        //     .create(on: database)
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(M14.tableName).delete()
  }
}

extension DocumentTag {
  var id: UUID {
    switch self {
      case .journal:
        return UUID(uuidString: "01b6f96e-1b8c-4c59-80ae-558411af9930")!
      case .letters:
        return UUID(uuidString: "298c9069-7a93-4b0e-bee3-99200ed46893")!
      case .exhortation:
        return UUID(uuidString: "2f39ac54-3ec8-4fe3-b09f-4f38c051eac8")!
      case .doctrinal:
        return UUID(uuidString: "401f8cde-3b62-41e6-b32e-43fe22c88c96")!
      case .treatise:
        return UUID(uuidString: "48479858-f259-4d6c-ab33-4b9104adb8ca")!
      case .history:
        return UUID(uuidString: "50ff8a67-c42b-4d7b-9127-9224b10d5aa4")!
      case .allegory:
        return UUID(uuidString: "7f459198-6e67-4c67-b543-26b40103abe2")!
      case .spiritualLife:
        return UUID(uuidString: "fa070ac4-ccf2-4524-ac10-c4f1e1adb92f")!
    }
  }
}
