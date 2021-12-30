// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Edition {
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

extension Edition.GraphQL.Schema {
  static var type: AppType<Edition> {
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
}

extension Edition.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let documentId: UUID
    let type: EditionType
    let editor: String?
    let isDraft: Bool
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
  }

  struct Update: Codable {
    let id: UUID
    let documentId: UUID
    let type: EditionType
    let editor: String?
    let isDraft: Bool
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
  }
}

extension Edition.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Edition.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Edition.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Edition.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Edition.GraphQL.Request.Inputs.Create]
  }
}

extension Edition.GraphQL.Schema.Inputs {
  static var create: AppInput<Edition.GraphQL.Request.Inputs.Create> {
    Input(Edition.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
      InputField("editor", at: \.editor)
      InputField("isDraft", at: \.isDraft)
      InputField("paperbackSplits", at: \.paperbackSplits)
      InputField("paperbackOverrideSize", at: \.paperbackOverrideSize)
    }
  }

  static var update: AppInput<Edition.GraphQL.Request.Inputs.Update> {
    Input(Edition.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("type", at: \.type)
      InputField("editor", at: \.editor)
      InputField("isDraft", at: \.isDraft)
      InputField("paperbackSplits", at: \.paperbackSplits)
      InputField("paperbackOverrideSize", at: \.paperbackOverrideSize)
    }
  }
}

extension Edition.GraphQL.Schema.Queries {
  static var get: AppField<Edition, IdentifyEntityArgs> {
    Field("getEdition", at: Resolver.getEdition) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Edition], NoArgs> {
    Field("getEditions", at: Resolver.getEditions)
  }
}

extension Edition.GraphQL.Schema.Mutations {
  static var create: AppField<Edition, Edition.GraphQL.Request.Args.Create> {
    Field("createEdition", at: Resolver.createEdition) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Edition], Edition.GraphQL.Request.Args.CreateMany> {
    Field("createEdition", at: Resolver.createEditions) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Edition, Edition.GraphQL.Request.Args.Update> {
    Field("createEdition", at: Resolver.updateEdition) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Edition], Edition.GraphQL.Request.Args.UpdateMany> {
    Field("createEdition", at: Resolver.updateEditions) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Edition, IdentifyEntityArgs> {
    Field("deleteEdition", at: Resolver.deleteEdition) {
      Argument("id", at: \.id)
    }
  }
}

extension Edition {
  convenience init(_ input: Edition.GraphQL.Request.Inputs.Create) throws {
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

  func update(_ input: Edition.GraphQL.Request.Inputs.Update) throws {
    self.documentId = .init(rawValue: input.documentId)
    self.type = input.type
    self.editor = input.editor
    self.isDraft = input.isDraft
    self.paperbackSplits = try? NonEmpty<[Int]>.fromArray(input.paperbackSplits ?? [])
    self.paperbackOverrideSize = input.paperbackOverrideSize
    self.updatedAt = Current.date()
  }
}
