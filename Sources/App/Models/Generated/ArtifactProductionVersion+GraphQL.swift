// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var ArtifactProductionVersionType: ModelType<ArtifactProductionVersion> {
    Type(ArtifactProductionVersion.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("version", at: \.version.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }

  struct CreateArtifactProductionVersionInput: Codable {
    let id: UUID?
    let version: String
  }

  struct UpdateArtifactProductionVersionInput: Codable {
    let id: UUID
    let version: String
  }

  struct CreateArtifactProductionVersionArgs: Codable {
    let input: AppSchema.CreateArtifactProductionVersionInput
  }

  struct UpdateArtifactProductionVersionArgs: Codable {
    let input: AppSchema.UpdateArtifactProductionVersionInput
  }

  struct CreateArtifactProductionVersionsArgs: Codable {
    let input: [AppSchema.CreateArtifactProductionVersionInput]
  }

  struct UpdateArtifactProductionVersionsArgs: Codable {
    let input: [AppSchema.UpdateArtifactProductionVersionInput]
  }

  static var CreateArtifactProductionVersionInputType: AppInput<
    AppSchema
      .CreateArtifactProductionVersionInput
  > {
    Input(AppSchema.CreateArtifactProductionVersionInput.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }

  static var UpdateArtifactProductionVersionInputType: AppInput<
    AppSchema
      .UpdateArtifactProductionVersionInput
  > {
    Input(AppSchema.UpdateArtifactProductionVersionInput.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }

  static var getArtifactProductionVersion: AppField<ArtifactProductionVersion, IdentifyEntityArgs> {
    Field("getArtifactProductionVersion", at: Resolver.getArtifactProductionVersion) {
      Argument("id", at: \.id)
    }
  }

  static var getArtifactProductionVersions: AppField<[ArtifactProductionVersion], NoArgs> {
    Field("getArtifactProductionVersions", at: Resolver.getArtifactProductionVersions)
  }

  static var createArtifactProductionVersion: AppField<
    ArtifactProductionVersion,
    AppSchema.CreateArtifactProductionVersionArgs
  > {
    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var createArtifactProductionVersions: AppField<
    [ArtifactProductionVersion],
    AppSchema.CreateArtifactProductionVersionsArgs
  > {
    Field("createArtifactProductionVersions", at: Resolver.createArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var updateArtifactProductionVersion: AppField<
    ArtifactProductionVersion,
    AppSchema.UpdateArtifactProductionVersionArgs
  > {
    Field("updateArtifactProductionVersion", at: Resolver.updateArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var updateArtifactProductionVersions: AppField<
    [ArtifactProductionVersion],
    AppSchema.UpdateArtifactProductionVersionsArgs
  > {
    Field("updateArtifactProductionVersions", at: Resolver.updateArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var deleteArtifactProductionVersion: AppField<
    ArtifactProductionVersion,
    IdentifyEntityArgs
  > {
    Field("deleteArtifactProductionVersion", at: Resolver.deleteArtifactProductionVersion) {
      Argument("id", at: \.id)
    }
  }
}

extension ArtifactProductionVersion {
  convenience init(_ input: AppSchema.CreateArtifactProductionVersionInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      version: .init(rawValue: input.version)
    )
  }

  convenience init(_ input: AppSchema.UpdateArtifactProductionVersionInput) {
    self.init(
      id: .init(rawValue: input.id),
      version: .init(rawValue: input.version)
    )
  }

  func update(_ input: AppSchema.UpdateArtifactProductionVersionInput) {
    version = .init(rawValue: input.version)
  }
}
