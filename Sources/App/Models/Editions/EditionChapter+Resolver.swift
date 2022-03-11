import Vapor

// below auto-generated

extension Resolver {
  func getEditionChapter(req: Req, args: IdentifyEntityArgs) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .queryEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.find(EditionChapter.self, byId: args.id)
    }
  }

  func getEditionChapters(req: Req, args: NoArgs) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.query(EditionChapter.self).all()
    }
  }

  func createEditionChapter(
    req: Req,
    args: InputArgs<AppSchema.CreateEditionChapterInput>
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      let editionChapter = EditionChapter(args.input)
      guard editionChapter.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(editionChapter)
      return try await Current.db.find(created.id)
    }
  }

  func createEditionChapters(
    req: Req,
    args: InputArgs<[AppSchema.CreateEditionChapterInput]>
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      let editionChapters = args.input.map(EditionChapter.init)
      guard editionChapters.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(editionChapters)
      return try await Current.db.query(EditionChapter.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateEditionChapter(
    req: Req,
    args: InputArgs<AppSchema.UpdateEditionChapterInput>
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      let editionChapter = EditionChapter(args.input)
      guard editionChapter.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(editionChapter)
      return try await Current.db.find(editionChapter.id)
    }
  }

  func updateEditionChapters(
    req: Req,
    args: InputArgs<[AppSchema.UpdateEditionChapterInput]>
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      let editionChapters = args.input.map(EditionChapter.init)
      guard editionChapters.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(editionChapters)
      return try await Current.db.query(EditionChapter.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteEditionChapter(req: Req, args: IdentifyEntityArgs) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.delete(EditionChapter.self, byId: args.id)
    }
  }
}
