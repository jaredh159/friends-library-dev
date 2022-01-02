import Vapor

extension Resolver {

  func createEditionChapter(
    req: Req,
    args: AppSchema.CreateEditionChapterArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      let chapter = EditionChapter(args.input)
      try await Current.db.createEditionChapter(chapter)
      return chapter
    }
  }

  func updateEditionChapter(
    req: Req,
    args: AppSchema.UpdateEditionChapterArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.updateEditionChapter(EditionChapter(args.input))
    }
  }

  func deleteEditionChapter(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      let chapter = try await Current.db.getEditionChapter(.init(rawValue: args.id))
      try await Current.db.deleteEditionChapter(chapter.id)
      return chapter
    }
  }

  func getEditionChapter(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .queryEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.getEditionChapter(.init(rawValue: args.id))
    }
  }
}

// below auto-generated

extension Resolver {

  func getEditionChapters(
    req: Req,
    args: NoArgs
  ) throws -> Future<[EditionChapter]> {
    throw Abort(.notImplemented, reason: "Resolver.getEditionChapters")
  }

  func createEditionChapters(
    req: Req,
    args: AppSchema.CreateEditionChaptersArgs
  ) throws -> Future<[EditionChapter]> {
    throw Abort(.notImplemented, reason: "Resolver.createEditionChapters")
  }

  func updateEditionChapters(
    req: Req,
    args: AppSchema.UpdateEditionChaptersArgs
  ) throws -> Future<[EditionChapter]> {
    throw Abort(.notImplemented, reason: "Resolver.updateEditionChapters")
  }
}
