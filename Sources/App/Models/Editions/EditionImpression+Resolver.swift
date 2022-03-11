import Vapor

// below auto-generated

extension Resolver {
  func getEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .queryEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.find(EditionImpression.self, byId: args.id)
    }
  }

  func getEditionImpressions(req: Req, args: NoArgs) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.query(EditionImpression.self).all()
    }
  }

  func createEditionImpression(
    req: Req,
    args: InputArgs<AppSchema.CreateEditionImpressionInput>
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      let editionImpression = try EditionImpression(args.input)
      guard editionImpression.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(editionImpression)
      return try await Current.db.find(created.id)
    }
  }

  func createEditionImpressions(
    req: Req,
    args: InputArgs<[AppSchema.CreateEditionImpressionInput]>
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      let editionImpressions = try args.input.map(EditionImpression.init)
      guard editionImpressions.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(editionImpressions)
      return try await Current.db.query(EditionImpression.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateEditionImpression(
    req: Req,
    args: InputArgs<AppSchema.UpdateEditionImpressionInput>
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      let editionImpression = try EditionImpression(args.input)
      guard editionImpression.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(editionImpression)
      return try await Current.db.find(editionImpression.id)
    }
  }

  func updateEditionImpressions(
    req: Req,
    args: InputArgs<[AppSchema.UpdateEditionImpressionInput]>
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      let editionImpressions = try args.input.map(EditionImpression.init)
      guard editionImpressions.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(editionImpressions)
      return try await Current.db.query(EditionImpression.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.delete(EditionImpression.self, byId: args.id)
    }
  }
}
