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
    args: CreateArtifactProductionVersionArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    let version = ArtifactProductionVersion(version: .init(rawValue: args.revision))
    let promise = req.eventLoop.makePromise(of: ArtifactProductionVersion.self)
    promise.completeWithTask {
      try await Current.db.createArtifactProductionVersion(version)
      return version
    }
    return promise.futureResult
  }

  func getLatestArtifactProductionVersion(
    req: Req,
    args: NoArgs
  ) throws -> Future<ArtifactProductionVersion> {
    let promise = req.eventLoop.makePromise(of: ArtifactProductionVersion.self)
    promise.completeWithTask {
      try await Current.db.getLatestArtifactProductionVersion()
    }
    return promise.futureResult
  }
}
