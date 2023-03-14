import DuetSQL
import Vapor

// below auto-generated

extension Resolver {
  func getIsbn(req: Req, args: IdentifyEntityArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.find(Isbn.self, byId: args.id)
    }
  }

  func getIsbns(req: Req, args: NoArgs) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Isbn].self, on: req.eventLoop) {
      try await Current.db.query(Isbn.self).all()
    }
  }

  func createIsbn(
    req: Req,
    args: InputArgs<AppSchema.CreateIsbnInput>
  ) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      let isbn = Isbn(args.input)
      guard isbn.isValid else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(isbn)
      return try await Current.db.find(created.id)
    }
  }

  func createIsbns(
    req: Req,
    args: InputArgs<[AppSchema.CreateIsbnInput]>
  ) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Isbn].self, on: req.eventLoop) {
      let isbns = args.input.map(Isbn.init)
      guard isbns.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(isbns)
      return try await Current.db.query(Isbn.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateIsbn(
    req: Req,
    args: InputArgs<AppSchema.UpdateIsbnInput>
  ) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      let isbn = Isbn(args.input)
      guard isbn.isValid else { throw ModelError.invalidEntity }
      try await Current.db.update(isbn)
      return try await Current.db.find(isbn.id)
    }
  }

  func updateIsbns(
    req: Req,
    args: InputArgs<[AppSchema.UpdateIsbnInput]>
  ) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Isbn].self, on: req.eventLoop) {
      let isbns = args.input.map(Isbn.init)
      guard isbns.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.update(isbns)
      return try await Current.db.query(Isbn.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteIsbn(req: Req, args: IdentifyEntityArgs) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.delete(Isbn.self, byId: args.id)
    }
  }
}
