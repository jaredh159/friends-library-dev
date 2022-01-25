import Vapor

extension Resolver {
  func getLatestArtifactProductionVersion(
    req: Req,
    args: NoArgs
  ) throws -> Future<ArtifactProductionVersion> {
    future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.query(ArtifactProductionVersion.self)
        .orderBy(.createdAt, .desc)
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
    try req.requirePermission(to: .queryEntities)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.find(ArtifactProductionVersion.self, byId: args.id)
    }
  }

  func getArtifactProductionVersions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.query(ArtifactProductionVersion.self).all()
    }
  }

  func createArtifactProductionVersion(
    req: Req,
    args: InputArgs<AppSchema.CreateArtifactProductionVersionInput>
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.create(ArtifactProductionVersion(args.input))
    }
  }

  func createArtifactProductionVersions(
    req: Req,
    args: InputArgs<[AppSchema.CreateArtifactProductionVersionInput]>
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(ArtifactProductionVersion.init))
    }
  }

  func updateArtifactProductionVersion(
    req: Req,
    args: InputArgs<AppSchema.UpdateArtifactProductionVersionInput>
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.update(ArtifactProductionVersion(args.input))
    }
  }

  func updateArtifactProductionVersions(
    req: Req,
    args: InputArgs<[AppSchema.UpdateArtifactProductionVersionInput]>
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(ArtifactProductionVersion.init))
    }
  }

  func deleteArtifactProductionVersion(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.delete(ArtifactProductionVersion.self, byId: args.id)
    }
  }
}
