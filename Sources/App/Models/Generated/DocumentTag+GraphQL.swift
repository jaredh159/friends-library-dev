// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var DocumentTagType: AppType<DocumentTag> {
    Type(DocumentTag.self) {
      Field("id", at: \.id.rawValue)
      Field("documentId", at: \.documentId.rawValue)
      Field("type", at: \.type)
      Field("createdAt", at: \.createdAt)
      Field("document", with: \.document)
    }
  }

  struct CreateDocumentTagInput: Codable {
    let id: UUID?
    let documentId: UUID
    let type: DocumentTag.TagType
  }

  struct UpdateDocumentTagInput: Codable {
    let id: UUID
    let documentId: UUID
    let type: DocumentTag.TagType
  }

  struct CreateDocumentTagArgs: Codable {
    let input: AppSchema.CreateDocumentTagInput
  }

  struct UpdateDocumentTagArgs: Codable {
    let input: AppSchema.UpdateDocumentTagInput
  }

  struct CreateDocumentTagsArgs: Codable {
    let input: [AppSchema.CreateDocumentTagInput]
  }

  struct UpdateDocumentTagsArgs: Codable {
    let input: [AppSchema.UpdateDocumentTagInput]
  }

  static var CreateDocumentTagInputType: AppInput<AppSchema.CreateDocumentTagInput> {
    Input(AppSchema.CreateDocumentTagInput.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
    }
  }

  static var UpdateDocumentTagInputType: AppInput<AppSchema.UpdateDocumentTagInput> {
    Input(AppSchema.UpdateDocumentTagInput.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
    }
  }

  static var getDocumentTag: AppField<DocumentTag, IdentifyEntityArgs> {
    Field("getDocumentTag", at: Resolver.getDocumentTag) {
      Argument("id", at: \.id)
    }
  }

  static var getDocumentTags: AppField<[DocumentTag], NoArgs> {
    Field("getDocumentTags", at: Resolver.getDocumentTags)
  }

  static var createDocumentTag: AppField<DocumentTag, AppSchema.CreateDocumentTagArgs> {
    Field("createDocumentTag", at: Resolver.createDocumentTag) {
      Argument("input", at: \.input)
    }
  }

  static var createDocumentTags: AppField<[DocumentTag], AppSchema.CreateDocumentTagsArgs> {
    Field("createDocumentTags", at: Resolver.createDocumentTags) {
      Argument("input", at: \.input)
    }
  }

  static var updateDocumentTag: AppField<DocumentTag, AppSchema.UpdateDocumentTagArgs> {
    Field("updateDocumentTag", at: Resolver.updateDocumentTag) {
      Argument("input", at: \.input)
    }
  }

  static var updateDocumentTags: AppField<[DocumentTag], AppSchema.UpdateDocumentTagsArgs> {
    Field("updateDocumentTags", at: Resolver.updateDocumentTags) {
      Argument("input", at: \.input)
    }
  }

  static var deleteDocumentTag: AppField<DocumentTag, IdentifyEntityArgs> {
    Field("deleteDocumentTag", at: Resolver.deleteDocumentTag) {
      Argument("id", at: \.id)
    }
  }
}

extension DocumentTag {
  convenience init(_ input: AppSchema.CreateDocumentTagInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      documentId: .init(rawValue: input.documentId),
      type: input.type
    )
  }

  convenience init(_ input: AppSchema.UpdateDocumentTagInput) {
    self.init(
      id: .init(rawValue: input.id),
      documentId: .init(rawValue: input.documentId),
      type: input.type
    )
  }

  func update(_ input: AppSchema.UpdateDocumentTagInput) {
    documentId = .init(rawValue: input.documentId)
    type = input.type
  }
}
