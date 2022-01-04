import Vapor

extension Resolver {
  func createEdition(req: Req, args: AppSchema.CreateEditionArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.createEdition(Edition(args.input))
    }
  }

  func getEdition(req: Req, args: IdentifyEntityArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .queryEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.getEdition(.init(rawValue: args.id))
    }
  }

  func updateEdition(req: Req, args: AppSchema.UpdateEditionArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.updateEdition(Edition(args.input))
    }
  }

  func deleteEdition(req: Req, args: IdentifyEntityArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.deleteEdition(.init(rawValue: args.id))
    }
  }
}

// below auto-generated

extension Resolver {

  func getEditions(req: Req, args: NoArgs) throws -> Future<[Edition]> {
    throw Abort(.notImplemented, reason: "Resolver.getEditions")
  }

  func createEditions(req: Req, args: AppSchema.CreateEditionsArgs) throws -> Future<[Edition]> {
    throw Abort(.notImplemented, reason: "Resolver.createEditions")
  }

  func updateEditions(req: Req, args: AppSchema.UpdateEditionsArgs) throws -> Future<[Edition]> {
    throw Abort(.notImplemented, reason: "Resolver.updateEditions")
  }
}
