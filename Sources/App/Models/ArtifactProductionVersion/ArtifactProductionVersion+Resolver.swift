import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  typealias Apv = ArtifactProductionVersion

  struct CreateArtifactProductionVersionArgs: Codable {
    let revision: String
  }

  func createArtifactProductionVersion(
    req: Req,
    args: Apv.GraphQL.Request.Args.Create
  ) throws -> Future<Apv> {
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
  ) throws -> Future<Apv> {
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.getLatestArtifactProductionVersion()
    }
  }

}

extension Resolver {
  func getArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Apv> {
    throw Abort(.notImplemented)
  }

  func getArtifactProductionVersions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Apv]> {
    throw Abort(.notImplemented)
  }

  func createArtifactProductionVersions(
    req: Req,
    args: Apv.GraphQL.Request.Args.CreateMany
  ) throws -> Future<[Apv]> {
    throw Abort(.notImplemented)
  }

  func updateArtifactProductionVersion(
    req: Req,
    args: Apv.GraphQL.Request.Args.Update
  ) throws -> Future<Apv> {
    throw Abort(.notImplemented)
  }

  func updateArtifactProductionVersions(
    req: Req,
    args: Apv.GraphQL.Request.Args.UpdateMany
  ) throws -> Future<[Apv]> {
    throw Abort(.notImplemented)
  }

  func deleteArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Apv> {
    throw Abort(.notImplemented)
  }
}
