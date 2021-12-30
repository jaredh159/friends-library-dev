// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var DocumentTagModelType: AppType<DocumentTagModel> {
    Type(DocumentTagModel.self) {
      Field("id", at: \.id.rawValue)
      Field("slug", at: \.slug)
      Field("createdAt", at: \.createdAt)
    }
  }

  struct CreateDocumentTagModelInput: Codable {
    let id: UUID?
    let slug: DocumentTag
  }

  struct UpdateDocumentTagModelInput: Codable {
    let id: UUID
    let slug: DocumentTag
  }

  struct CreateDocumentTagModelArgs: Codable {
    let input: AppSchema.CreateDocumentTagModelInput
  }

  struct UpdateDocumentTagModelArgs: Codable {
    let input: AppSchema.UpdateDocumentTagModelInput
  }

  struct CreateDocumentTagModelsArgs: Codable {
    let input: [AppSchema.CreateDocumentTagModelInput]
  }

  struct UpdateDocumentTagModelsArgs: Codable {
    let input: [AppSchema.UpdateDocumentTagModelInput]
  }

  static var CreateDocumentTagModelInputType: AppInput<AppSchema.CreateDocumentTagModelInput> {
    Input(AppSchema.CreateDocumentTagModelInput.self) {
      InputField("id", at: \.id)
      InputField("slug", at: \.slug)
    }
  }

  static var UpdateDocumentTagModelInputType: AppInput<AppSchema.UpdateDocumentTagModelInput> {
    Input(AppSchema.UpdateDocumentTagModelInput.self) {
      InputField("id", at: \.id)
      InputField("slug", at: \.slug)
    }
  }

  static var getDocumentTagModel: AppField<DocumentTagModel, IdentifyEntityArgs> {
    Field("getDocumentTagModel", at: Resolver.getDocumentTagModel) {
      Argument("id", at: \.id)
    }
  }

  static var getDocumentTagModels: AppField<[DocumentTagModel], NoArgs> {
    Field("getDocumentTagModels", at: Resolver.getDocumentTagModels)
  }

  static var createDocumentTagModel: AppField<DocumentTagModel, AppSchema.CreateDocumentTagModelArgs> {
    Field("createDocumentTagModel", at: Resolver.createDocumentTagModel) {
      Argument("input", at: \.input)
    }
  }

  static var createDocumentTagModels: AppField<[DocumentTagModel], AppSchema.CreateDocumentTagModelsArgs> {
    Field("createDocumentTagModels", at: Resolver.createDocumentTagModels) {
      Argument("input", at: \.input)
    }
  }

  static var updateDocumentTagModel: AppField<DocumentTagModel, AppSchema.UpdateDocumentTagModelArgs> {
    Field("updateDocumentTagModel", at: Resolver.updateDocumentTagModel) {
      Argument("input", at: \.input)
    }
  }

  static var updateDocumentTagModels: AppField<[DocumentTagModel], AppSchema.UpdateDocumentTagModelsArgs> {
    Field("updateDocumentTagModels", at: Resolver.updateDocumentTagModels) {
      Argument("input", at: \.input)
    }
  }

  static var deleteDocumentTagModel: AppField<DocumentTagModel, IdentifyEntityArgs> {
    Field("deleteDocumentTagModel", at: Resolver.deleteDocumentTagModel) {
      Argument("id", at: \.id)
    }
  }
}

extension DocumentTagModel {
  convenience init(_ input: AppSchema.CreateDocumentTagModelInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      slug: input.slug
    )
  }

  func update(_ input: AppSchema.UpdateDocumentTagModelInput) {
    self.slug = input.slug
  }
}
