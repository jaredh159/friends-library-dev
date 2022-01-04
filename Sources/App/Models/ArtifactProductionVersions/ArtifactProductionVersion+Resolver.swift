import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  struct CreateArtifactProductionVersionArgs: Codable {
    let revision: String
  }

  func createArtifactProductionVersion(
    req: Req,
    args: AppSchema.CreateArtifactProductionVersionArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      let version = ArtifactProductionVersion(version: .init(rawValue: args.input.version))
      return try await Current.db.createArtifactProductionVersion(version)
    }
  }

  func getLatestArtifactProductionVersion(
    req: Req,
    args: NoArgs
  ) throws -> Future<ArtifactProductionVersion> {
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.getLatestArtifactProductionVersion()
    }
  }
}

// below auto-generated

extension Resolver {
  func getArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<ArtifactProductionVersion> {
    throw Abort(.notImplemented)
  }

  func getArtifactProductionVersions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    throw Abort(.notImplemented)
  }

  func createArtifactProductionVersions(
    req: Req,
    args: AppSchema.CreateArtifactProductionVersionsArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    throw Abort(.notImplemented)
  }

  func updateArtifactProductionVersion(
    req: Req,
    args: AppSchema.UpdateArtifactProductionVersionArgs
  ) throws -> Future<ArtifactProductionVersion> {
    throw Abort(.notImplemented)
  }

  func updateArtifactProductionVersions(
    req: Req,
    args: AppSchema.UpdateArtifactProductionVersionsArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    throw Abort(.notImplemented)
  }

  func deleteArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<ArtifactProductionVersion> {
    throw Abort(.notImplemented)
  }
}
