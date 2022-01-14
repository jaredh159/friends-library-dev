import Vapor

// below auto-generated

extension Resolver {
  func getIsbn(req: Req, args: IdentifyEntityArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.find(Isbn.self, byId: args.id)
    }
  }

  func getIsbns(req: Req, args: NoArgs) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Isbn].self, on: req.eventLoop) {
      try await Current.db.query(Isbn.self).all()
    }
  }

  func createIsbn(
    req: Req,
    args: AppSchema.CreateIsbnArgs
  ) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.create(Isbn(args.input))
    }
  }

  func createIsbns(
    req: Req,
    args: AppSchema.CreateIsbnsArgs
  ) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Isbn].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Isbn.init))
    }
  }

  func updateIsbn(
    req: Req,
    args: AppSchema.UpdateIsbnArgs
  ) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.update(Isbn(args.input))
    }
  }

  func updateIsbns(
    req: Req,
    args: AppSchema.UpdateIsbnsArgs
  ) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Isbn].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Isbn.init))
    }
  }

  func deleteIsbn(req: Req, args: IdentifyEntityArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.delete(Isbn.self, byId: args.id)
    }
  }
}
