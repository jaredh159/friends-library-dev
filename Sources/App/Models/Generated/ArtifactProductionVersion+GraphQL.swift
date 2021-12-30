// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension ArtifactProductionVersion {
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

extension ArtifactProductionVersion.GraphQL.Schema {
  static var type: AppType<ArtifactProductionVersion> {
    Type(ArtifactProductionVersion.self) {
      Field("id", at: \.id.rawValue)
      Field("version", at: \.version.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension ArtifactProductionVersion.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let version: String
  }

  struct Update: Codable {
    let id: UUID
    let version: String
  }
}

extension ArtifactProductionVersion.GraphQL.Request.Args {
  struct Create: Codable {
    let input: ArtifactProductionVersion.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: ArtifactProductionVersion.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [ArtifactProductionVersion.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [ArtifactProductionVersion.GraphQL.Request.Inputs.Create]
  }
}

extension ArtifactProductionVersion.GraphQL.Schema.Inputs {
  static var create: AppInput<ArtifactProductionVersion.GraphQL.Request.Inputs.Create> {
    Input(ArtifactProductionVersion.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }

  static var update: AppInput<ArtifactProductionVersion.GraphQL.Request.Inputs.Update> {
    Input(ArtifactProductionVersion.GraphQL.Request.Inputs.Update.self) {
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
  static var create: AppField<ArtifactProductionVersion, ArtifactProductionVersion.GraphQL.Request.Args.Create> {
    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[ArtifactProductionVersion], ArtifactProductionVersion.GraphQL.Request.Args.CreateMany> {
    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<ArtifactProductionVersion, ArtifactProductionVersion.GraphQL.Request.Args.Update> {
    Field("createArtifactProductionVersion", at: Resolver.updateArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[ArtifactProductionVersion], ArtifactProductionVersion.GraphQL.Request.Args.UpdateMany> {
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
  convenience init(_ input: ArtifactProductionVersion.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      version: .init(rawValue: input.version)
    )
  }

  func update(_ input: ArtifactProductionVersion.GraphQL.Request.Inputs.Update) throws {
    self.version = .init(rawValue: input.version)
  }
}
