// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension EditionImpression {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
  }
}

extension EditionImpression.GraphQL.Schema {
  static var type: AppType<EditionImpression> {
    Type(EditionImpression.self) {
      Field("id", at: \.id.rawValue)
      Field("editionId", at: \.editionId.rawValue)
      Field("adocLength", at: \.adocLength)
      Field("paperbackSize", at: \.paperbackSize)
      Field("paperbackVolumes", at: \.paperbackVolumes.rawValue)
      Field("publishedRevision", at: \.publishedRevision.rawValue)
      Field("productionToolchainRevision", at: \.productionToolchainRevision.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension EditionImpression.GraphQL.Request {
  struct CreateEditionImpressionInput: Codable {
    let id: UUID?
    let editionId: UUID
    let adocLength: Int
    let paperbackSize: PrintSizeVariant
    let paperbackVolumes: [Int]
    let publishedRevision: String
    let productionToolchainRevision: String
  }

  struct UpdateEditionImpressionInput: Codable {
    let id: UUID
    let editionId: UUID
    let adocLength: Int
    let paperbackSize: PrintSizeVariant
    let paperbackVolumes: [Int]
    let publishedRevision: String
    let productionToolchainRevision: String
  }
}

extension EditionImpression.GraphQL.Request {
  struct CreateEditionImpressionArgs: Codable {
    let input: EditionImpression.GraphQL.Request.CreateEditionImpressionInput
  }

  struct UpdateEditionImpressionArgs: Codable {
    let input: EditionImpression.GraphQL.Request.UpdateEditionImpressionInput
  }

  struct CreateEditionImpressionsArgs: Codable {
    let input: [EditionImpression.GraphQL.Request.CreateEditionImpressionInput]
  }

  struct UpdateEditionImpressionsArgs: Codable {
    let input: [EditionImpression.GraphQL.Request.UpdateEditionImpressionInput]
  }
}

extension EditionImpression.GraphQL.Schema {
  static var create: AppInput<EditionImpression.GraphQL.Request.CreateEditionImpressionInput> {
    Input(EditionImpression.GraphQL.Request.CreateEditionImpressionInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("adocLength", at: \.adocLength)
      InputField("paperbackSize", at: \.paperbackSize)
      InputField("paperbackVolumes", at: \.paperbackVolumes)
      InputField("publishedRevision", at: \.publishedRevision)
      InputField("productionToolchainRevision", at: \.productionToolchainRevision)
    }
  }

  static var update: AppInput<EditionImpression.GraphQL.Request.UpdateEditionImpressionInput> {
    Input(EditionImpression.GraphQL.Request.UpdateEditionImpressionInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("adocLength", at: \.adocLength)
      InputField("paperbackSize", at: \.paperbackSize)
      InputField("paperbackVolumes", at: \.paperbackVolumes)
      InputField("publishedRevision", at: \.publishedRevision)
      InputField("productionToolchainRevision", at: \.productionToolchainRevision)
    }
  }
}

extension EditionImpression.GraphQL.Schema.Queries {
  static var get: AppField<EditionImpression, IdentifyEntityArgs> {
    Field("getEditionImpression", at: Resolver.getEditionImpression) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[EditionImpression], NoArgs> {
    Field("getEditionImpressions", at: Resolver.getEditionImpressions)
  }
}

extension EditionImpression.GraphQL.Schema.Mutations {
  static var create: AppField<EditionImpression, EditionImpression.GraphQL.Request.CreateEditionImpressionArgs> {
    Field("createEditionImpression", at: Resolver.createEditionImpression) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[EditionImpression], EditionImpression.GraphQL.Request.CreateEditionImpressionsArgs> {
    Field("createEditionImpression", at: Resolver.createEditionImpressions) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<EditionImpression, EditionImpression.GraphQL.Request.UpdateEditionImpressionArgs> {
    Field("createEditionImpression", at: Resolver.updateEditionImpression) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[EditionImpression], EditionImpression.GraphQL.Request.UpdateEditionImpressionsArgs> {
    Field("createEditionImpression", at: Resolver.updateEditionImpressions) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<EditionImpression, IdentifyEntityArgs> {
    Field("deleteEditionImpression", at: Resolver.deleteEditionImpression) {
      Argument("id", at: \.id)
    }
  }
}

extension EditionImpression {
  convenience init(_ input: EditionImpression.GraphQL.Request.CreateEditionImpressionInput) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      editionId: .init(rawValue: input.editionId),
      adocLength: input.adocLength,
      paperbackSize: input.paperbackSize,
      paperbackVolumes: try NonEmpty<[Int]>.fromArray(input.paperbackVolumes),
      publishedRevision: .init(rawValue: input.publishedRevision),
      productionToolchainRevision: .init(rawValue: input.productionToolchainRevision)
    )
  }

  func update(_ input: EditionImpression.GraphQL.Request.UpdateEditionImpressionInput) throws {
    self.editionId = .init(rawValue: input.editionId)
    self.adocLength = input.adocLength
    self.paperbackSize = input.paperbackSize
    self.paperbackVolumes = try NonEmpty<[Int]>.fromArray(input.paperbackVolumes)
    self.publishedRevision = .init(rawValue: input.publishedRevision)
    self.productionToolchainRevision = .init(rawValue: input.productionToolchainRevision)
  }
}
