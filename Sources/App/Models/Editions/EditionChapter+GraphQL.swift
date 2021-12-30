// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension EditionChapter {
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

extension EditionChapter.GraphQL.Schema {
  static var type: AppType<EditionChapter> {
    Type(EditionChapter.self) {
      Field("id", at: \.id.rawValue)
      Field("editionId", at: \.editionId.rawValue)
      Field("order", at: \.order)
      Field("shortHeading", at: \.shortHeading)
      Field("isIntermediateTitle", at: \.isIntermediateTitle)
      Field("customId", at: \.customId)
      Field("sequenceNumber", at: \.sequenceNumber)
      Field("nonSequenceTitle", at: \.nonSequenceTitle)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension EditionChapter.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let editionId: UUID
    let order: Int
    let shortHeading: String
    let isIntermediateTitle: Bool
    let customId: String?
    let sequenceNumber: Int?
    let nonSequenceTitle: String?
  }

  struct Update: Codable {
    let id: UUID
    let editionId: UUID
    let order: Int
    let shortHeading: String
    let isIntermediateTitle: Bool
    let customId: String?
    let sequenceNumber: Int?
    let nonSequenceTitle: String?
  }
}

extension EditionChapter.GraphQL.Request.Args {
  struct Create: Codable {
    let input: EditionChapter.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: EditionChapter.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [EditionChapter.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [EditionChapter.GraphQL.Request.Inputs.Create]
  }
}

extension EditionChapter.GraphQL.Schema.Inputs {
  static var create: AppInput<EditionChapter.GraphQL.Request.Inputs.Create> {
    Input(EditionChapter.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("order", at: \.order)
      InputField("shortHeading", at: \.shortHeading)
      InputField("isIntermediateTitle", at: \.isIntermediateTitle)
      InputField("customId", at: \.customId)
      InputField("sequenceNumber", at: \.sequenceNumber)
      InputField("nonSequenceTitle", at: \.nonSequenceTitle)
    }
  }

  static var update: AppInput<EditionChapter.GraphQL.Request.Inputs.Update> {
    Input(EditionChapter.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("order", at: \.order)
      InputField("shortHeading", at: \.shortHeading)
      InputField("isIntermediateTitle", at: \.isIntermediateTitle)
      InputField("customId", at: \.customId)
      InputField("sequenceNumber", at: \.sequenceNumber)
      InputField("nonSequenceTitle", at: \.nonSequenceTitle)
    }
  }
}

extension EditionChapter.GraphQL.Schema.Queries {
  static var get: AppField<EditionChapter, IdentifyEntityArgs> {
    Field("getEditionChapter", at: Resolver.getEditionChapter) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[EditionChapter], NoArgs> {
    Field("getEditionChapters", at: Resolver.getEditionChapters)
  }
}

extension EditionChapter.GraphQL.Schema.Mutations {
  static var create: AppField<EditionChapter, EditionChapter.GraphQL.Request.Args.Create> {
    Field("createEditionChapter", at: Resolver.createEditionChapter) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[EditionChapter], EditionChapter.GraphQL.Request.Args.CreateMany> {
    Field("createEditionChapter", at: Resolver.createEditionChapters) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<EditionChapter, EditionChapter.GraphQL.Request.Args.Update> {
    Field("createEditionChapter", at: Resolver.updateEditionChapter) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[EditionChapter], EditionChapter.GraphQL.Request.Args.UpdateMany> {
    Field("createEditionChapter", at: Resolver.updateEditionChapters) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<EditionChapter, IdentifyEntityArgs> {
    Field("deleteEditionChapter", at: Resolver.deleteEditionChapter) {
      Argument("id", at: \.id)
    }
  }
}

extension EditionChapter {
  convenience init(_ input: EditionChapter.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      editionId: .init(rawValue: input.editionId),
      order: input.order,
      shortHeading: input.shortHeading,
      isIntermediateTitle: input.isIntermediateTitle,
      customId: input.customId,
      sequenceNumber: input.sequenceNumber,
      nonSequenceTitle: input.nonSequenceTitle
    )
  }

  func update(_ input: EditionChapter.GraphQL.Request.Inputs.Update) throws {
    self.editionId = .init(rawValue: input.editionId)
    self.order = input.order
    self.shortHeading = input.shortHeading
    self.isIntermediateTitle = input.isIntermediateTitle
    self.customId = input.customId
    self.sequenceNumber = input.sequenceNumber
    self.nonSequenceTitle = input.nonSequenceTitle
    self.updatedAt = Current.date()
  }
}
