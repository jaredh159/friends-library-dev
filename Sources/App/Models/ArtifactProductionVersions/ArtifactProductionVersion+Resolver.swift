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
    args: ArtifactProductionVersion.GraphQL.Request.Args.Create
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    let version = ArtifactProductionVersion(version: .init(rawValue: args.input.version))
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.createArtifactProductionVersion(version)
      return version
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
    args: ArtifactProductionVersion.GraphQL.Request.Args.CreateMany
  ) throws -> Future<[ArtifactProductionVersion]> {
    throw Abort(.notImplemented)
  }

  func updateArtifactProductionVersion(
    req: Req,
    args: ArtifactProductionVersion.GraphQL.Request.Args.Update
  ) throws -> Future<ArtifactProductionVersion> {
    throw Abort(.notImplemented)
  }

  func updateArtifactProductionVersions(
    req: Req,
    args: ArtifactProductionVersion.GraphQL.Request.Args.UpdateMany
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
