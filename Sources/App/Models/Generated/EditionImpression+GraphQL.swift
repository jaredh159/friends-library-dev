// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var EditionImpressionType: ModelType<EditionImpression> {
    Type(EditionImpression.self) {
      Field("id", at: \.id.rawValue)
      Field("editionId", at: \.editionId.rawValue)
      Field("adocLength", at: \.adocLength)
      Field("paperbackSize", at: \.paperbackSize)
      Field("paperbackVolumes", at: \.paperbackVolumes.rawValue)
      Field("publishedRevision", at: \.publishedRevision.rawValue)
      Field("productionToolchainRevision", at: \.productionToolchainRevision.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("paperbackPriceInCents", at: \.paperbackPrice.rawValue)
      Field("files", at: \.files)
      Field("edition", with: \.edition)
    }
  }

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

  struct CreateEditionImpressionArgs: Codable {
    let input: AppSchema.CreateEditionImpressionInput
  }

  struct UpdateEditionImpressionArgs: Codable {
    let input: AppSchema.UpdateEditionImpressionInput
  }

  struct CreateEditionImpressionsArgs: Codable {
    let input: [AppSchema.CreateEditionImpressionInput]
  }

  struct UpdateEditionImpressionsArgs: Codable {
    let input: [AppSchema.UpdateEditionImpressionInput]
  }

  static var CreateEditionImpressionInputType: AppInput<AppSchema.CreateEditionImpressionInput> {
    Input(AppSchema.CreateEditionImpressionInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("adocLength", at: \.adocLength)
      InputField("paperbackSize", at: \.paperbackSize)
      InputField("paperbackVolumes", at: \.paperbackVolumes)
      InputField("publishedRevision", at: \.publishedRevision)
      InputField("productionToolchainRevision", at: \.productionToolchainRevision)
    }
  }

  static var UpdateEditionImpressionInputType: AppInput<AppSchema.UpdateEditionImpressionInput> {
    Input(AppSchema.UpdateEditionImpressionInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("adocLength", at: \.adocLength)
      InputField("paperbackSize", at: \.paperbackSize)
      InputField("paperbackVolumes", at: \.paperbackVolumes)
      InputField("publishedRevision", at: \.publishedRevision)
      InputField("productionToolchainRevision", at: \.productionToolchainRevision)
    }
  }

  static var getEditionImpression: AppField<EditionImpression, IdentifyEntityArgs> {
    Field("getEditionImpression", at: Resolver.getEditionImpression) {
      Argument("id", at: \.id)
    }
  }

  static var getEditionImpressions: AppField<[EditionImpression], NoArgs> {
    Field("getEditionImpressions", at: Resolver.getEditionImpressions)
  }

  static var createEditionImpression: AppField<
    EditionImpression,
    AppSchema.CreateEditionImpressionArgs
  > {
    Field("createEditionImpression", at: Resolver.createEditionImpression) {
      Argument("input", at: \.input)
    }
  }

  static var createEditionImpressions: AppField<
    [EditionImpression],
    AppSchema.CreateEditionImpressionsArgs
  > {
    Field("createEditionImpressions", at: Resolver.createEditionImpressions) {
      Argument("input", at: \.input)
    }
  }

  static var updateEditionImpression: AppField<
    EditionImpression,
    AppSchema.UpdateEditionImpressionArgs
  > {
    Field("updateEditionImpression", at: Resolver.updateEditionImpression) {
      Argument("input", at: \.input)
    }
  }

  static var updateEditionImpressions: AppField<
    [EditionImpression],
    AppSchema.UpdateEditionImpressionsArgs
  > {
    Field("updateEditionImpressions", at: Resolver.updateEditionImpressions) {
      Argument("input", at: \.input)
    }
  }

  static var deleteEditionImpression: AppField<EditionImpression, IdentifyEntityArgs> {
    Field("deleteEditionImpression", at: Resolver.deleteEditionImpression) {
      Argument("id", at: \.id)
    }
  }
}

extension EditionImpression {
  convenience init(_ input: AppSchema.CreateEditionImpressionInput) throws {
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

  convenience init(_ input: AppSchema.UpdateEditionImpressionInput) throws {
    self.init(
      id: .init(rawValue: input.id),
      editionId: .init(rawValue: input.editionId),
      adocLength: input.adocLength,
      paperbackSize: input.paperbackSize,
      paperbackVolumes: try NonEmpty<[Int]>.fromArray(input.paperbackVolumes),
      publishedRevision: .init(rawValue: input.publishedRevision),
      productionToolchainRevision: .init(rawValue: input.productionToolchainRevision)
    )
  }

  func update(_ input: AppSchema.UpdateEditionImpressionInput) throws {
    editionId = .init(rawValue: input.editionId)
    adocLength = input.adocLength
    paperbackSize = input.paperbackSize
    paperbackVolumes = try NonEmpty<[Int]>.fromArray(input.paperbackVolumes)
    publishedRevision = .init(rawValue: input.publishedRevision)
    productionToolchainRevision = .init(rawValue: input.productionToolchainRevision)
  }
}
