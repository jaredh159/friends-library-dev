import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  func createDownload(
    req: Req,
    args: Download.GraphQL.Request.Args.Create
  ) throws -> Future<Download> {
    try req.requirePermission(to: .mutateDownloads)
    let download = Download(args.input)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.createDownload(download)
      return download
    }
  }
}
