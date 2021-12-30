// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension DocumentTagModel {
  enum GraphQL {
    enum Schema {
      enum Inputs {}
      enum Queries {}
      enum Mutations {}
    }
    enum Request {
      enum Inputs {}
      enum Args {}
    }
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

extension DocumentTagModel.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let slug: DocumentTag
  }

  struct Update: Codable {
    let id: UUID
    let slug: DocumentTag
  }
}

extension DocumentTagModel.GraphQL.Request.Args {
  struct Create: Codable {
    let input: DocumentTagModel.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: DocumentTagModel.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [DocumentTagModel.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [DocumentTagModel.GraphQL.Request.Inputs.Create]
  }
}

extension DocumentTagModel.GraphQL.Schema.Inputs {
  static var create: AppInput<DocumentTagModel.GraphQL.Request.Inputs.Create> {
    Input(DocumentTagModel.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("slug", at: \.slug)
    }
  }

  static var update: AppInput<DocumentTagModel.GraphQL.Request.Inputs.Update> {
    Input(DocumentTagModel.GraphQL.Request.Inputs.Update.self) {
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
  static var create: AppField<DocumentTagModel, DocumentTagModel.GraphQL.Request.Args.Create> {
    Field("createDocumentTagModel", at: Resolver.createDocumentTagModel) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[DocumentTagModel], DocumentTagModel.GraphQL.Request.Args.CreateMany> {
    Field("createDocumentTagModel", at: Resolver.createDocumentTagModels) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<DocumentTagModel, DocumentTagModel.GraphQL.Request.Args.Update> {
    Field("createDocumentTagModel", at: Resolver.updateDocumentTagModel) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[DocumentTagModel], DocumentTagModel.GraphQL.Request.Args.UpdateMany> {
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
  convenience init(_ input: DocumentTagModel.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      slug: input.slug
    )
  }

  func update(_ input: DocumentTagModel.GraphQL.Request.Inputs.Update) throws {
    self.slug = input.slug
  }
}
