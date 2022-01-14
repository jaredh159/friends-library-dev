import Vapor

// below auto-generated

extension Resolver {
  func getEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .queryFriends)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.find(EditionImpression.self, byId: args.id)
    }
  }

  func getEditionImpressions(req: Req, args: NoArgs) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.query(EditionImpression.self).all()
    }
  }

  func createEditionImpression(
    req: Req,
    args: AppSchema.CreateEditionImpressionArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.create(EditionImpression(args.input))
    }
  }

  func createEditionImpressions(
    req: Req,
    args: AppSchema.CreateEditionImpressionsArgs
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(EditionImpression.init))
    }
  }

  func updateEditionImpression(
    req: Req,
    args: AppSchema.UpdateEditionImpressionArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.update(EditionImpression(args.input))
    }
  }

  func updateEditionImpressions(
    req: Req,
    args: AppSchema.UpdateEditionImpressionsArgs
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(EditionImpression.init))
    }
  }

  func deleteEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.delete(EditionImpression.self, byId: args.id)
    }
  }
}
