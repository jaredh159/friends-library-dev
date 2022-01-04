import Vapor

// below auto-generated

extension Resolver {
  func getEditionChapter(req: Req, args: IdentifyEntityArgs) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .queryEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.getEditionChapter(.init(rawValue: args.id))
    }
  }

  func getEditionChapters(req: Req, args: NoArgs) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .queryEditionChapters)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.getEditionChapters()
    }
  }

  func createEditionChapter(
    req: Req,
    args: AppSchema.CreateEditionChapterArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.createEditionChapter(EditionChapter(args.input))
    }
  }

  func createEditionChapters(
    req: Req,
    args: AppSchema.CreateEditionChaptersArgs
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.createEditionChapters(args.input.map(EditionChapter.init))
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

  func updateEditionChapters(
    req: Req,
    args: AppSchema.UpdateEditionChaptersArgs
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.updateEditionChapters(args.input.map(EditionChapter.init))
    }
  }

  func deleteEditionChapter(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEditionChapters)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.deleteEditionChapter(.init(rawValue: args.id))
    }
  }
}
