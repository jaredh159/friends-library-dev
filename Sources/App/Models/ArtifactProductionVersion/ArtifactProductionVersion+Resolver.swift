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
