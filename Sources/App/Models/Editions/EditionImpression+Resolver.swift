import Vapor

// below auto-generated

extension Resolver {
  func getEditionImpression(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .queryEditionImpressions)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.getEditionImpression(.init(rawValue: args.id))
    }
  }

  func getEditionImpressions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .queryEditionImpressions)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.getEditionImpressions(nil)
    }
  }

  func createEditionImpression(
    req: Req,
    args: AppSchema.CreateEditionImpressionArgs
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEditionImpressions)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.createEditionImpression(EditionImpression(args.input))
    }
  }

  func createEditionImpressions(
    req: Req,
    args: AppSchema.CreateEditionImpressionsArgs
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateEditionImpressions)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.createEditionImpressions(args.input.map(EditionImpression.init))
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

  func updateEditionImpressions(
    req: Req,
    args: AppSchema.UpdateEditionImpressionsArgs
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateEditionImpressions)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.updateEditionImpressions(args.input.map(EditionImpression.init))
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
