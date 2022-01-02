import Vapor

extension Resolver {

  func createIsbn(req: Req, args: AppSchema.CreateIsbnArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateIsbns)
    return future(of: Isbn.self, on: req.eventLoop) {
      let isbn = Isbn(args.input)
      try await Current.db.createIsbn(isbn)
      return isbn
    }
  }

  func getIsbn(req: Req, args: IdentifyEntityArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .queryIsbns)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.getIsbn(.init(rawValue: args.id))
    }
  }

  func updateIsbn(req: Req, args: AppSchema.UpdateIsbnArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateIsbns)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.updateIsbn(Isbn(args.input))
    }
  }

  func deleteIsbn(req: Req, args: IdentifyEntityArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateIsbns)
    return future(of: Isbn.self, on: req.eventLoop) {
      let isbn = try await Current.db.getIsbn(.init(rawValue: args.id))
      try await Current.db.deleteIsbn(isbn.id)
      return isbn
    }
  }
}

// below auto-generated

extension Resolver {
  func getIsbns(req: Req, args: NoArgs) throws -> Future<[Isbn]> {
    throw Abort(.notImplemented, reason: "Resolver.getIsbns")
  }

  func createIsbns(req: Req, args: AppSchema.CreateIsbnsArgs) throws -> Future<[Isbn]> {
    throw Abort(.notImplemented, reason: "Resolver.createIsbns")
  }

  func updateIsbns(req: Req, args: AppSchema.UpdateIsbnsArgs) throws -> Future<[Isbn]> {
    throw Abort(.notImplemented, reason: "Resolver.updateIsbns")
  }
}
