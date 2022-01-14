import Vapor

extension Resolver {
  func getLatestArtifactProductionVersion(
    req: Req,
    args: NoArgs
  ) throws -> Future<ArtifactProductionVersion> {
    future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.query(ArtifactProductionVersion.self)
        .orderBy(ArtifactProductionVersion[.createdAt], by: .desc)
        .first()
    }
  }
}

// below auto-generated

extension Resolver {
  func getArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .queryFriends)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.find(ArtifactProductionVersion.self, byId: args.id)
    }
  }

  func getArtifactProductionVersions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.query(ArtifactProductionVersion.self).all()
    }
  }

  func createArtifactProductionVersion(
    req: Req,
    args: AppSchema.CreateArtifactProductionVersionArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.create(ArtifactProductionVersion(args.input))
    }
  }

  func createArtifactProductionVersions(
    req: Req,
    args: AppSchema.CreateArtifactProductionVersionsArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(ArtifactProductionVersion.init))
    }
  }

  func updateArtifactProductionVersion(
    req: Req,
    args: AppSchema.UpdateArtifactProductionVersionArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.update(ArtifactProductionVersion(args.input))
    }
  }

  func updateArtifactProductionVersions(
    req: Req,
    args: AppSchema.UpdateArtifactProductionVersionsArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(ArtifactProductionVersion.init))
    }
  }

  func deleteArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.delete(ArtifactProductionVersion.self, byId: args.id)
    }
  }
}
