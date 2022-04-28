// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var EditionType: ModelType<Edition> {
    Type(Edition.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("documentId", at: \.documentId.rawValue.lowercased)
      Field("type", at: \.type)
      Field("editor", at: \.editor)
      Field("isDraft", at: \.isDraft)
      Field("paperbackSplits", at: \.paperbackSplits?.rawValue)
      Field("paperbackOverrideSize", at: \.paperbackOverrideSize)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("lang", at: \.lang)
      Field("directoryPath", at: \.directoryPath)
      Field("filename", at: \.filename)
      Field("images", at: \.images)
      Field("isValid", at: \.isValid)
      Field("document", with: \.document)
      Field("impression", with: \.impression)
      Field("isbn", with: \.isbn)
      Field("audio", with: \.audio)
      Field("chapters", with: \.chapters)
    }
  }

  struct CreateEditionInput: Codable {
    let id: UUID?
    let documentId: UUID
    let type: EditionType
    let editor: String?
    let isDraft: Bool?
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
    let deletedAt: String?
  }

  struct UpdateEditionInput: Codable {
    let id: UUID
    let documentId: UUID
    let type: EditionType
    let editor: String?
    let isDraft: Bool
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
    let deletedAt: String?
  }

  static var CreateEditionInputType: AppInput<CreateEditionInput> {
    Input(CreateEditionInput.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
      InputField("editor", at: \.editor)
      InputField("isDraft", at: \.isDraft)
      InputField("paperbackSplits", at: \.paperbackSplits)
      InputField("paperbackOverrideSize", at: \.paperbackOverrideSize)
      InputField("deletedAt", at: \.deletedAt)
    }
  }

  static var UpdateEditionInputType: AppInput<UpdateEditionInput> {
    Input(UpdateEditionInput.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
      InputField("editor", at: \.editor)
      InputField("isDraft", at: \.isDraft)
      InputField("paperbackSplits", at: \.paperbackSplits)
      InputField("paperbackOverrideSize", at: \.paperbackOverrideSize)
      InputField("deletedAt", at: \.deletedAt)
    }
  }

  static var getEdition: AppField<Edition, IdentifyEntityArgs> {
    Field("getEdition", at: Resolver.getEdition) {
      Argument("id", at: \.id)
    }
  }

  static var getEditions: AppField<[Edition], NoArgs> {
    Field("getEditions", at: Resolver.getEditions)
  }

  static var createEdition: AppField<Edition, InputArgs<CreateEditionInput>> {
    Field("createEdition", at: Resolver.createEdition) {
      Argument("input", at: \.input)
    }
  }

  static var createEditions: AppField<[Edition], InputArgs<[CreateEditionInput]>> {
    Field("createEditions", at: Resolver.createEditions) {
      Argument("input", at: \.input)
    }
  }

  static var updateEdition: AppField<Edition, InputArgs<UpdateEditionInput>> {
    Field("updateEdition", at: Resolver.updateEdition) {
      Argument("input", at: \.input)
    }
  }

  static var updateEditions: AppField<[Edition], InputArgs<[UpdateEditionInput]>> {
    Field("updateEditions", at: Resolver.updateEditions) {
      Argument("input", at: \.input)
    }
  }

  static var deleteEdition: AppField<Edition, IdentifyEntityArgs> {
    Field("deleteEdition", at: Resolver.deleteEdition) {
      Argument("id", at: \.id)
    }
  }
}

extension Edition {
  convenience init(_ input: AppSchema.CreateEditionInput) {
    self.init(
      documentId: .init(rawValue: input.documentId),
      type: input.type,
      editor: input.editor,
      paperbackSplits: try? NonEmpty<[Int]>.fromArray(input.paperbackSplits ?? []),
      paperbackOverrideSize: input.paperbackOverrideSize
    )
    if let id = input.id {
      self.id = .init(rawValue: id)
    }
    if let isDraft = input.isDraft {
      self.isDraft = isDraft
    }
  }

  convenience init(_ input: AppSchema.UpdateEditionInput) {
    self.init(
      id: .init(rawValue: input.id),
      documentId: .init(rawValue: input.documentId),
      type: input.type,
      editor: input.editor,
      isDraft: input.isDraft,
      paperbackSplits: try? NonEmpty<[Int]>.fromArray(input.paperbackSplits ?? []),
      paperbackOverrideSize: input.paperbackOverrideSize
    )
  }

  func update(_ input: AppSchema.UpdateEditionInput) throws {
    documentId = .init(rawValue: input.documentId)
    type = input.type
    editor = input.editor
    isDraft = input.isDraft
    paperbackSplits = try? NonEmpty<[Int]>.fromArray(input.paperbackSplits ?? [])
    paperbackOverrideSize = input.paperbackOverrideSize
    deletedAt = try input.deletedAt.flatMap { try Date(fromIsoString: $0) }
    updatedAt = Current.date()
  }
}
