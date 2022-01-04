import Vapor

// below auto-generated

extension Resolver {
  func getEdition(req: Req, args: IdentifyEntityArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .queryEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.getEdition(.init(rawValue: args.id))
    }
  }

  func getEditions(req: Req, args: NoArgs) throws -> Future<[Edition]> {
    try req.requirePermission(to: .queryEditions)
    return future(of: [Edition].self, on: req.eventLoop) {
      try await Current.db.getEditions()
    }
  }

  func createEdition(req: Req, args: AppSchema.CreateEditionArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.createEdition(Edition(args.input))
    }
  }

  func createEditions(req: Req, args: AppSchema.CreateEditionsArgs) throws -> Future<[Edition]> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: [Edition].self, on: req.eventLoop) {
      try await Current.db.createEditions(args.input.map(Edition.init))
    }
  }

  func updateEdition(req: Req, args: AppSchema.UpdateEditionArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.updateEdition(Edition(args.input))
    }
  }

  func updateEditions(req: Req, args: AppSchema.UpdateEditionsArgs) throws -> Future<[Edition]> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: [Edition].self, on: req.eventLoop) {
      try await Current.db.updateEditions(args.input.map(Edition.init))
    }
  }

  func deleteEdition(req: Req, args: IdentifyEntityArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEditions)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.deleteEdition(.init(rawValue: args.id))
    }
  }
}
