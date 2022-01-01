import Fluent
import Foundation

struct CreateTags: AsyncMigration {
  private typealias M15 = DocumentTagModel.M15

  func prepare(on database: Database) async throws {
    let tags = try await database.enum(M15.DocumentTagEnum.name)
      .case(M15.DocumentTagEnum.caseJournal)
      .case(M15.DocumentTagEnum.caseLetters)
      .case(M15.DocumentTagEnum.caseExhortation)
      .case(M15.DocumentTagEnum.caseDoctrinal)
      .case(M15.DocumentTagEnum.caseTreatise)
      .case(M15.DocumentTagEnum.caseHistory)
      .case(M15.DocumentTagEnum.caseAllegory)
      .case(M15.DocumentTagEnum.caseSpiritualLife)
      .create()

    try await database.schema(M15.tableName)
      .id()
      .field(M15.slug, tags, .required)
      .field(.createdAt, .datetime, .required)
      .unique(on: M15.slug)
      .create()

    let models = DocumentTag.allCases.map { tag in
      DocumentTagModel(id: .init(rawValue: tag.id), slug: tag)
    }

    try await Current.db.createDocumentTagModels(models)
  }

  func revert(on database: Database) async throws {
    try await database.schema(M15.tableName).delete()
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

extension DocumentTagModel {
  enum M15 {
    static let tableName = "document_tags"
    static let slug = FieldKey("slug")
    enum DocumentTagEnum {
      static let name = "document_tags_enum"
      static let caseJournal = "journal"
      static let caseLetters = "letters"
      static let caseExhortation = "exhortation"
      static let caseDoctrinal = "doctrinal"
      static let caseTreatise = "treatise"
      static let caseHistory = "history"
      static let caseAllegory = "allegory"
      static let caseSpiritualLife = "spiritualLife"
    }
  }
}

extension DocumentTag: PostgresEnum {
  var dataType: String {
    DocumentTagModel.M15.DocumentTagEnum.name
  }
}
