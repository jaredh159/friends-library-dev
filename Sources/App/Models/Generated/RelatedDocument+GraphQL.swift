// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var RelatedDocumentType: ModelType<RelatedDocument> {
    Type(RelatedDocument.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("description", at: \.description)
      Field("documentId", at: \.documentId.rawValue.lowercased)
      Field("parentDocumentId", at: \.parentDocumentId.rawValue.lowercased)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("document", with: \.document)
      Field("parentDocument", with: \.parentDocument)
    }
  }

  struct CreateRelatedDocumentInput: Codable {
    let id: UUID?
    let description: String
    let documentId: UUID
    let parentDocumentId: UUID
  }

  struct UpdateRelatedDocumentInput: Codable {
    let id: UUID
    let description: String
    let documentId: UUID
    let parentDocumentId: UUID
  }

  struct CreateRelatedDocumentArgs: Codable {
    let input: AppSchema.CreateRelatedDocumentInput
  }

  struct UpdateRelatedDocumentArgs: Codable {
    let input: AppSchema.UpdateRelatedDocumentInput
  }

  struct CreateRelatedDocumentsArgs: Codable {
    let input: [AppSchema.CreateRelatedDocumentInput]
  }

  struct UpdateRelatedDocumentsArgs: Codable {
    let input: [AppSchema.UpdateRelatedDocumentInput]
  }

  static var CreateRelatedDocumentInputType: AppInput<AppSchema.CreateRelatedDocumentInput> {
    Input(AppSchema.CreateRelatedDocumentInput.self) {
      InputField("id", at: \.id)
      InputField("description", at: \.description)
      InputField("documentId", at: \.documentId)
      InputField("parentDocumentId", at: \.parentDocumentId)
    }
  }

  static var UpdateRelatedDocumentInputType: AppInput<AppSchema.UpdateRelatedDocumentInput> {
    Input(AppSchema.UpdateRelatedDocumentInput.self) {
      InputField("id", at: \.id)
      InputField("description", at: \.description)
      InputField("documentId", at: \.documentId)
      InputField("parentDocumentId", at: \.parentDocumentId)
    }
  }

  static var getRelatedDocument: AppField<RelatedDocument, IdentifyEntityArgs> {
    Field("getRelatedDocument", at: Resolver.getRelatedDocument) {
      Argument("id", at: \.id)
    }
  }

  static var getRelatedDocuments: AppField<[RelatedDocument], NoArgs> {
    Field("getRelatedDocuments", at: Resolver.getRelatedDocuments)
  }

  static var createRelatedDocument: AppField<RelatedDocument, AppSchema.CreateRelatedDocumentArgs> {
    Field("createRelatedDocument", at: Resolver.createRelatedDocument) {
      Argument("input", at: \.input)
    }
  }

  static var createRelatedDocuments: AppField<
    [RelatedDocument],
    AppSchema.CreateRelatedDocumentsArgs
  > {
    Field("createRelatedDocuments", at: Resolver.createRelatedDocuments) {
      Argument("input", at: \.input)
    }
  }

  static var updateRelatedDocument: AppField<RelatedDocument, AppSchema.UpdateRelatedDocumentArgs> {
    Field("updateRelatedDocument", at: Resolver.updateRelatedDocument) {
      Argument("input", at: \.input)
    }
  }

  static var updateRelatedDocuments: AppField<
    [RelatedDocument],
    AppSchema.UpdateRelatedDocumentsArgs
  > {
    Field("updateRelatedDocuments", at: Resolver.updateRelatedDocuments) {
      Argument("input", at: \.input)
    }
  }

  static var deleteRelatedDocument: AppField<RelatedDocument, IdentifyEntityArgs> {
    Field("deleteRelatedDocument", at: Resolver.deleteRelatedDocument) {
      Argument("id", at: \.id)
    }
  }
}

extension RelatedDocument {
  convenience init(_ input: AppSchema.CreateRelatedDocumentInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      description: input.description,
      documentId: .init(rawValue: input.documentId),
      parentDocumentId: .init(rawValue: input.parentDocumentId)
    )
  }

  convenience init(_ input: AppSchema.UpdateRelatedDocumentInput) {
    self.init(
      id: .init(rawValue: input.id),
      description: input.description,
      documentId: .init(rawValue: input.documentId),
      parentDocumentId: .init(rawValue: input.parentDocumentId)
    )
  }

  func update(_ input: AppSchema.UpdateRelatedDocumentInput) {
    description = input.description
    documentId = .init(rawValue: input.documentId)
    parentDocumentId = .init(rawValue: input.parentDocumentId)
    updatedAt = Current.date()
  }
}
