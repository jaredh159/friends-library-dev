// auto-generated, do not edit
import Graphiti
import Vapor

extension ArtifactProductionVersion {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
  }
}

extension ArtifactProductionVersion.GraphQL.Schema {
  static var type: AppType<ArtifactProductionVersion> {
    Type(ArtifactProductionVersion.self) {
      Field("id", at: \.id.rawValue)
      Field("version", at: \.version.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension ArtifactProductionVersion.GraphQL.Request {
  struct CreateArtifactProductionVersionInput: Codable {
    let id: UUID?
    let version: String
  }

  struct UpdateArtifactProductionVersionInput: Codable {
    let id: UUID
    let version: String
  }
}

extension ArtifactProductionVersion.GraphQL.Request {
  struct CreateArtifactProductionVersionArgs: Codable {
    let input: ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionInput
  }

  struct UpdateArtifactProductionVersionArgs: Codable {
    let input: ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionInput
  }

  struct CreateArtifactProductionVersionsArgs: Codable {
    let input: [ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionInput]
  }

  struct UpdateArtifactProductionVersionsArgs: Codable {
    let input: [ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionInput]
  }
}

extension ArtifactProductionVersion.GraphQL.Schema {
  static var create: AppInput<ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionInput> {
    Input(ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionInput.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }

  static var update: AppInput<ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionInput> {
    Input(ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionInput.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }
}

extension ArtifactProductionVersion.GraphQL.Schema.Queries {
  static var get: AppField<ArtifactProductionVersion, IdentifyEntityArgs> {
    Field("getArtifactProductionVersion", at: Resolver.getArtifactProductionVersion) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[ArtifactProductionVersion], NoArgs> {
    Field("getArtifactProductionVersions", at: Resolver.getArtifactProductionVersions)
  }
}

extension ArtifactProductionVersion.GraphQL.Schema.Mutations {
  static var create: AppField<ArtifactProductionVersion, ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionArgs> {
    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[ArtifactProductionVersion], ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionsArgs> {
    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<ArtifactProductionVersion, ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionArgs> {
    Field("createArtifactProductionVersion", at: Resolver.updateArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[ArtifactProductionVersion], ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionsArgs> {
    Field("createArtifactProductionVersion", at: Resolver.updateArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<ArtifactProductionVersion, IdentifyEntityArgs> {
    Field("deleteArtifactProductionVersion", at: Resolver.deleteArtifactProductionVersion) {
      Argument("id", at: \.id)
    }
  }
}

extension ArtifactProductionVersion {
  convenience init(_ input: ArtifactProductionVersion.GraphQL.Request.CreateArtifactProductionVersionInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      version: .init(rawValue: input.version)
    )
  }

  func update(_ input: ArtifactProductionVersion.GraphQL.Request.UpdateArtifactProductionVersionInput) {
    self.version = .init(rawValue: input.version)
  }
}
