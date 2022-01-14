import Vapor

// below auto-generated

extension Resolver {
  func getEditionChapter(req: Req, args: IdentifyEntityArgs) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .queryFriends)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.find(EditionChapter.self, byId: args.id)
    }
  }

  func getEditionChapters(req: Req, args: NoArgs) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.query(EditionChapter.self).all()
    }
  }

  func createEditionChapter(
    req: Req,
    args: AppSchema.CreateEditionChapterArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.create(EditionChapter(args.input))
    }
  }

  func createEditionChapters(
    req: Req,
    args: AppSchema.CreateEditionChaptersArgs
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(EditionChapter.init))
    }
  }

  func updateEditionChapter(
    req: Req,
    args: AppSchema.UpdateEditionChapterArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.update(EditionChapter(args.input))
    }
  }

  func updateEditionChapters(
    req: Req,
    args: AppSchema.UpdateEditionChaptersArgs
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(EditionChapter.init))
    }
  }

  func deleteEditionChapter(req: Req, args: IdentifyEntityArgs) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.delete(EditionChapter.self, byId: args.id)
    }
  }
}
