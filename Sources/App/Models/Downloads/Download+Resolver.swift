import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  func createDownload(
    req: Req,
    args: AppSchema.CreateDownloadArgs
  ) throws -> Future<Download> {
    try req.requirePermission(to: .mutateDownloads)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.createDownload(Download(args.input))
    }
  }
}

// below auto-generated

extension Resolver {
  func getDownload(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Download> {
    throw Abort(.notImplemented)
  }

  func getDownloads(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Download]> {
    throw Abort(.notImplemented)
  }

  func createDownloads(
    req: Req,
    args: AppSchema.CreateDownloadsArgs
  ) throws -> Future<[Download]> {
    throw Abort(.notImplemented)
  }

  func updateDownload(
    req: Req,
    args: AppSchema.UpdateDownloadArgs
  ) throws -> Future<Download> {
    throw Abort(.notImplemented)
  }

  func updateDownloads(
    req: Req,
    args: AppSchema.UpdateDownloadsArgs
  ) throws -> Future<[Download]> {
    throw Abort(.notImplemented)
  }

  func deleteDownload(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Download> {
    throw Abort(.notImplemented)
  }
}
