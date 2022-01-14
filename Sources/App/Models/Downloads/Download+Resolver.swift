import Vapor

// below auto-generated

extension Resolver {
  func getDownload(req: Req, args: IdentifyEntityArgs) throws -> Future<Download> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.find(Download.self, byId: args.id)
    }
  }

  func getDownloads(req: Req, args: NoArgs) throws -> Future<[Download]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.query(Download.self).all()
    }
  }

  func createDownload(
    req: Req,
    args: AppSchema.CreateDownloadArgs
  ) throws -> Future<Download> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.create(Download(args.input))
    }
  }

  func createDownloads(
    req: Req,
    args: AppSchema.CreateDownloadsArgs
  ) throws -> Future<[Download]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Download.init))
    }
  }

  func updateDownload(
    req: Req,
    args: AppSchema.UpdateDownloadArgs
  ) throws -> Future<Download> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.update(Download(args.input))
    }
  }

  func updateDownloads(
    req: Req,
    args: AppSchema.UpdateDownloadsArgs
  ) throws -> Future<[Download]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Download.init))
    }
  }

  func deleteDownload(req: Req, args: IdentifyEntityArgs) throws -> Future<Download> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.delete(Download.self, byId: args.id)
    }
  }
}
