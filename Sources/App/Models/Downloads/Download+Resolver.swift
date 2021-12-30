import Fluent
import Foundation
import Graphiti
import Vapor

struct CreateDownloadInput: Codable {
  let documentId: UUID
  let editionType: EditionType
  let format: Download.Format
  let source: Download.DownloadSource
  let isMobile: Bool
  let audioQuality: Download.AudioQuality?
  let audioPartNumber: Int?
  let userAgent: String?
  let os: String?
  let browser: String?
  let platform: String?
  let referrer: String?
  let ip: String?
  let city: String?
  let region: String?
  let postalCode: String?
  let country: String?
  let latitude: String?
  let longitude: String?
}

extension Resolver {
  struct CreateDownloadArgs: Codable {
    let input: CreateDownloadInput
  }

  // func createDownload(
  //   request: Request,
  //   args: CreateDownloadArgs
  // ) throws -> Future<Download> {
  //   try request.requirePermission(to: .mutateDownloads)
  //   let input = args.input
  //   let download = Download(
  //     documentId: .init(rawValue: input.documentId),
  //     editionType: input.editionType,
  //     format: input.format,
  //     source: input.source,
  //     isMobile: input.isMobile,
  //     audioQuality: input.audioQuality,
  //     audioPartNumber: input.audioPartNumber,
  //     userAgent: input.userAgent,
  //     os: input.os,
  //     browser: input.browser,
  //     platform: input.platform,
  //     referrer: input.referrer,
  //     ip: input.ip,
  //     city: input.city,
  //     region: input.region,
  //     postalCode: input.postalCode,
  //     country: input.country,
  //     latitude: input.latitude,
  //     longitude: input.longitude
  //   )
  //   return future(of: Download.self, on: request.eventLoop) {
  //     try await Current.db.createDownload(download)
  //     return download
  //   }
  // }
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

  func createDownload(
    req: Req,
    args: Download.GraphQL.Request.Args.Create
  ) throws -> Future<Download> {
    throw Abort(.notImplemented)
  }

  func createDownloads(
    req: Req,
    args: Download.GraphQL.Request.Args.CreateMany
  ) throws -> Future<[Download]> {
    throw Abort(.notImplemented)
  }

  func updateDownload(
    req: Req,
    args: Download.GraphQL.Request.Args.Update
  ) throws -> Future<Download> {
    throw Abort(.notImplemented)
  }

  func updateDownloads(
    req: Req,
    args: Download.GraphQL.Request.Args.UpdateMany
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
