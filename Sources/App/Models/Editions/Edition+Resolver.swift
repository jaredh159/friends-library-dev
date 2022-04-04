import DuetSQL
import Graphiti
import Vapor

extension Resolver {
  func deleteEditionEditionChapters(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      return try await Current.db.query(EditionChapter.self)
        .where(.editionId == args.id)
        .delete()
    }
  }

  func createEdition(
    req: Req,
    args: InputArgs<AppSchema.CreateEditionInput>
  ) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      let isbn: Isbn
      do {
        isbn = try await Current.db.query(Isbn.self).where(.isNull(.editionId)).first()
      } catch {
        await slackError("Failed to query ISBN to assign to new edition: \(error)")
        throw error
      }
      let edition = try Edition(args.input)
      guard edition.isValid else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(edition)
      isbn.editionId = created.id
      try await Current.db.update(isbn)
      return try await Current.db.find(created.id)
    }
  }
}

extension AppSchema {
  static var deleteEditionEditionChapters: AppField<[EditionChapter], IdentifyEntityArgs> {
    Field("deleteEditionEditionChapters", at: Resolver.deleteEditionEditionChapters) {
      Argument("id", at: \.id)
    }
  }
}

// below auto-generated

extension Resolver {
  func getEdition(req: Req, args: IdentifyEntityArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.find(Edition.self, byId: args.id)
    }
  }

  func getEditions(req: Req, args: NoArgs) throws -> Future<[Edition]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Edition].self, on: req.eventLoop) {
      try await Current.db.query(Edition.self).all()
    }
  }

  func createEditions(
    req: Req,
    args: InputArgs<[AppSchema.CreateEditionInput]>
  ) throws -> Future<[Edition]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Edition].self, on: req.eventLoop) {
      let editions = try args.input.map(Edition.init)
      guard editions.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(editions)
      return try await Current.db.query(Edition.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateEdition(
    req: Req,
    args: InputArgs<AppSchema.UpdateEditionInput>
  ) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      let edition = try Edition(args.input)
      guard edition.isValid else { throw ModelError.invalidEntity }
      try await Current.db.update(edition)
      return try await Current.db.find(edition.id)
    }
  }

  func updateEditions(
    req: Req,
    args: InputArgs<[AppSchema.UpdateEditionInput]>
  ) throws -> Future<[Edition]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Edition].self, on: req.eventLoop) {
      let editions = try args.input.map(Edition.init)
      guard editions.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.update(editions)
      return try await Current.db.query(Edition.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteEdition(req: Req, args: IdentifyEntityArgs) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.delete(Edition.self, byId: args.id)
    }
  }
}
