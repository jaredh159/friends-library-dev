// auto-generated, do not edit
import Graphiti
import Vapor

extension DocumentTagModel {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
  }
}

extension DocumentTagModel.GraphQL.Schema {
  static var type: AppType<DocumentTagModel> {
    Type(DocumentTagModel.self) {
      Field("id", at: \.id.rawValue)
      Field("slug", at: \.slug)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension DocumentTagModel.GraphQL.Request {
  struct CreateDocumentTagModelInput: Codable {
    let id: UUID?
    let slug: DocumentTag
  }

  struct UpdateDocumentTagModelInput: Codable {
    let id: UUID
    let slug: DocumentTag
  }
}

extension DocumentTagModel.GraphQL.Request {
  struct CreateDocumentTagModelArgs: Codable {
    let input: DocumentTagModel.GraphQL.Request.CreateDocumentTagModelInput
  }

  struct UpdateDocumentTagModelArgs: Codable {
    let input: DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelInput
  }

  struct CreateDocumentTagModelsArgs: Codable {
    let input: [DocumentTagModel.GraphQL.Request.CreateDocumentTagModelInput]
  }

  struct UpdateDocumentTagModelsArgs: Codable {
    let input: [DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelInput]
  }
}

extension DocumentTagModel.GraphQL.Schema {
  static var create: AppInput<DocumentTagModel.GraphQL.Request.CreateDocumentTagModelInput> {
    Input(DocumentTagModel.GraphQL.Request.CreateDocumentTagModelInput.self) {
      InputField("id", at: \.id)
      InputField("slug", at: \.slug)
    }
  }

  static var update: AppInput<DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelInput> {
    Input(DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelInput.self) {
      InputField("id", at: \.id)
      InputField("slug", at: \.slug)
    }
  }
}

extension DocumentTagModel.GraphQL.Schema.Queries {
  static var get: AppField<DocumentTagModel, IdentifyEntityArgs> {
    Field("getDocumentTagModel", at: Resolver.getDocumentTagModel) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[DocumentTagModel], NoArgs> {
    Field("getDocumentTagModels", at: Resolver.getDocumentTagModels)
  }
}

extension DocumentTagModel.GraphQL.Schema.Mutations {
  static var create: AppField<DocumentTagModel, DocumentTagModel.GraphQL.Request.CreateDocumentTagModelArgs> {
    Field("createDocumentTagModel", at: Resolver.createDocumentTagModel) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[DocumentTagModel], DocumentTagModel.GraphQL.Request.CreateDocumentTagModelsArgs> {
    Field("createDocumentTagModel", at: Resolver.createDocumentTagModels) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<DocumentTagModel, DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelArgs> {
    Field("createDocumentTagModel", at: Resolver.updateDocumentTagModel) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[DocumentTagModel], DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelsArgs> {
    Field("createDocumentTagModel", at: Resolver.updateDocumentTagModels) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<DocumentTagModel, IdentifyEntityArgs> {
    Field("deleteDocumentTagModel", at: Resolver.deleteDocumentTagModel) {
      Argument("id", at: \.id)
    }
  }
}

extension DocumentTagModel {
  convenience init(_ input: DocumentTagModel.GraphQL.Request.CreateDocumentTagModelInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      slug: input.slug
    )
  }

  func update(_ input: DocumentTagModel.GraphQL.Request.UpdateDocumentTagModelInput) {
    self.slug = input.slug
  }
}
