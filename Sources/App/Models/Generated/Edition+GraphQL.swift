// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var EditionType: AppType<Edition> {
    Type(Edition.self) {
      Field("id", at: \.id.rawValue)
      Field("documentId", at: \.documentId.rawValue)
      Field("type", at: \.type)
      Field("editor", at: \.editor)
      Field("isDraft", at: \.isDraft)
      Field("paperbackSplits", at: \.paperbackSplits?.rawValue)
      Field("paperbackOverrideSize", at: \.paperbackOverrideSize)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }

  struct CreateEditionInput: Codable {
    let id: UUID?
    let documentId: UUID
    let type: EditionType
    let editor: String?
    let isDraft: Bool
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
  }

  struct UpdateEditionInput: Codable {
    let id: UUID
    let documentId: UUID
    let type: EditionType
    let editor: String?
    let isDraft: Bool
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
  }

  struct CreateEditionArgs: Codable {
    let input: AppSchema.CreateEditionInput
  }

  struct UpdateEditionArgs: Codable {
    let input: AppSchema.UpdateEditionInput
  }

  struct CreateEditionsArgs: Codable {
    let input: [AppSchema.CreateEditionInput]
  }

  struct UpdateEditionsArgs: Codable {
    let input: [AppSchema.UpdateEditionInput]
  }

  static var CreateEditionInputType: AppInput<AppSchema.CreateEditionInput> {
    Input(AppSchema.CreateEditionInput.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
      InputField("editor", at: \.editor)
      InputField("isDraft", at: \.isDraft)
      InputField("paperbackSplits", at: \.paperbackSplits)
      InputField("paperbackOverrideSize", at: \.paperbackOverrideSize)
    }
  }

  static var UpdateEditionInputType: AppInput<AppSchema.UpdateEditionInput> {
    Input(AppSchema.UpdateEditionInput.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
      InputField("editor", at: \.editor)
      InputField("isDraft", at: \.isDraft)
      InputField("paperbackSplits", at: \.paperbackSplits)
      InputField("paperbackOverrideSize", at: \.paperbackOverrideSize)
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

  static var createEdition: AppField<Edition, AppSchema.CreateEditionArgs> {
    Field("createEdition", at: Resolver.createEdition) {
      Argument("input", at: \.input)
    }
  }

  static var createEditions: AppField<[Edition], AppSchema.CreateEditionsArgs> {
    Field("createEditions", at: Resolver.createEditions) {
      Argument("input", at: \.input)
    }
  }

  static var updateEdition: AppField<Edition, AppSchema.UpdateEditionArgs> {
    Field("updateEdition", at: Resolver.updateEdition) {
      Argument("input", at: \.input)
    }
  }

  static var updateEditions: AppField<[Edition], AppSchema.UpdateEditionsArgs> {
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
  convenience init(_ input: AppSchema.CreateEditionInput) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      documentId: .init(rawValue: input.documentId),
      type: input.type,
      editor: input.editor,
      isDraft: input.isDraft,
      paperbackSplits: try? NonEmpty<[Int]>.fromArray(input.paperbackSplits ?? []),
      paperbackOverrideSize: input.paperbackOverrideSize
    )
  }

  convenience init(_ input: AppSchema.UpdateEditionInput) throws {
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
    self.documentId = .init(rawValue: input.documentId)
    self.type = input.type
    self.editor = input.editor
    self.isDraft = input.isDraft
    self.paperbackSplits = try? NonEmpty<[Int]>.fromArray(input.paperbackSplits ?? [])
    self.paperbackOverrideSize = input.paperbackOverrideSize
    self.updatedAt = Current.date()
  }
}
