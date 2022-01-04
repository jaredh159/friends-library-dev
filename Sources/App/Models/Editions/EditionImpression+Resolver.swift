import Vapor

extension Resolver {
  func createEditionImpression(
    req: Req,
    args: AppSchema.CreateEditionImpressionArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEditionImpressions)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.createEditionImpression(EditionImpression(args.input))
    }
  }

  func getEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .queryEditionImpressions)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.getEditionImpression(.init(rawValue: args.id))
    }
  }

  func updateEditionImpression(
    req: Req,
    args: AppSchema.UpdateEditionImpressionArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEditionImpressions)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.updateEditionImpression(EditionImpression(args.input))
    }
  }

  func deleteEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEditionImpressions)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.deleteEditionImpression(.init(rawValue: args.id))
    }
  }
}

// below auto-generated

extension Resolver {

  func getEditionImpressions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[EditionImpression]> {
    throw Abort(.notImplemented, reason: "Resolver.getEditionImpressions")
  }

  func createEditionImpressions(
    req: Req,
    args: AppSchema.CreateEditionImpressionsArgs
  ) throws -> Future<[EditionImpression]> {
    throw Abort(.notImplemented, reason: "Resolver.createEditionImpressions")
  }

  func updateEditionImpressions(
    req: Req,
    args: AppSchema.UpdateEditionImpressionsArgs
  ) throws -> Future<[EditionImpression]> {
    throw Abort(.notImplemented, reason: "Resolver.updateEditionImpressions")
  }
}
