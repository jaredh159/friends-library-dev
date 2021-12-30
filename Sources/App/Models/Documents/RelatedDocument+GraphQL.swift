// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension RelatedDocument {
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

extension RelatedDocument.GraphQL.Schema {
  static var type: AppType<RelatedDocument> {
    Type(RelatedDocument.self) {
      Field("id", at: \.id.rawValue)
      Field("description", at: \.description)
      Field("documentId", at: \.documentId.rawValue)
      Field("parentDocumentId", at: \.parentDocumentId.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension RelatedDocument.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let description: String
    let documentId: UUID
    let parentDocumentId: UUID
  }

  struct Update: Codable {
    let id: UUID
    let description: String
    let documentId: UUID
    let parentDocumentId: UUID
  }
}

extension RelatedDocument.GraphQL.Request.Args {
  struct Create: Codable {
    let input: RelatedDocument.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: RelatedDocument.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [RelatedDocument.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [RelatedDocument.GraphQL.Request.Inputs.Create]
  }
}

extension RelatedDocument.GraphQL.Schema.Inputs {
  static var create: AppInput<RelatedDocument.GraphQL.Request.Inputs.Create> {
    Input(RelatedDocument.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("description", at: \.description)
      InputField("documentId", at: \.documentId)
      InputField("parentDocumentId", at: \.parentDocumentId)
    }
  }

  static var update: AppInput<RelatedDocument.GraphQL.Request.Inputs.Update> {
    Input(RelatedDocument.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("description", at: \.description)
      InputField("documentId", at: \.documentId)
      InputField("parentDocumentId", at: \.parentDocumentId)
    }
  }
}

extension RelatedDocument.GraphQL.Schema.Queries {
  static var get: AppField<RelatedDocument, IdentifyEntityArgs> {
    Field("getRelatedDocument", at: Resolver.getRelatedDocument) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[RelatedDocument], NoArgs> {
    Field("getRelatedDocuments", at: Resolver.getRelatedDocuments)
  }
}

extension RelatedDocument.GraphQL.Schema.Mutations {
  static var create: AppField<RelatedDocument, RelatedDocument.GraphQL.Request.Args.Create> {
    Field("createRelatedDocument", at: Resolver.createRelatedDocument) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[RelatedDocument], RelatedDocument.GraphQL.Request.Args.CreateMany> {
    Field("createRelatedDocument", at: Resolver.createRelatedDocuments) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<RelatedDocument, RelatedDocument.GraphQL.Request.Args.Update> {
    Field("createRelatedDocument", at: Resolver.updateRelatedDocument) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[RelatedDocument], RelatedDocument.GraphQL.Request.Args.UpdateMany> {
    Field("createRelatedDocument", at: Resolver.updateRelatedDocuments) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<RelatedDocument, IdentifyEntityArgs> {
    Field("deleteRelatedDocument", at: Resolver.deleteRelatedDocument) {
      Argument("id", at: \.id)
    }
  }
}

extension RelatedDocument {
  convenience init(_ input: RelatedDocument.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      description: input.description,
      documentId: .init(rawValue: input.documentId),
      parentDocumentId: .init(rawValue: input.parentDocumentId)
    )
  }

  func update(_ input: RelatedDocument.GraphQL.Request.Inputs.Update) throws {
    self.description = input.description
    self.documentId = .init(rawValue: input.documentId)
    self.parentDocumentId = .init(rawValue: input.parentDocumentId)
    self.updatedAt = Current.date()
  }
}
