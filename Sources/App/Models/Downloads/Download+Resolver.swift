import Vapor

// below auto-generated

extension Resolver {
  func getDownload(req: Req, args: IdentifyEntityArgs) throws -> Future<Download> {
    try req.requirePermission(to: .queryDownloads)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.getDownload(.init(rawValue: args.id))
    }
  }

  func getDownloads(req: Req, args: NoArgs) throws -> Future<[Download]> {
    try req.requirePermission(to: .queryDownloads)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.getDownloads()
    }
  }

  func createDownload(req: Req, args: AppSchema.CreateDownloadArgs) throws -> Future<Download> {
    try req.requirePermission(to: .mutateDownloads)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.createDownload(Download(args.input))
    }
  }

  func createDownloads(req: Req, args: AppSchema.CreateDownloadsArgs) throws -> Future<[Download]> {
    try req.requirePermission(to: .mutateDownloads)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.createDownloads(args.input.map(Download.init))
    }
  }

  func updateDownload(req: Req, args: AppSchema.UpdateDownloadArgs) throws -> Future<Download> {
    try req.requirePermission(to: .mutateDownloads)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.updateDownload(Download(args.input))
    }
  }

  func updateDownloads(req: Req, args: AppSchema.UpdateDownloadsArgs) throws -> Future<[Download]> {
    try req.requirePermission(to: .mutateDownloads)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.updateDownloads(args.input.map(Download.init))
    }
  }

  func deleteDownload(req: Req, args: IdentifyEntityArgs) throws -> Future<Download> {
    try req.requirePermission(to: .mutateDownloads)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.deleteDownload(.init(rawValue: args.id))
    }
  }
}
