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

  func createDownload(
    request: Request,
    args: CreateDownloadArgs
  ) throws -> Future<Download> {
    try request.requirePermission(to: .mutateDownloads)
    let download = Download()
    download.documentId = args.input.documentId
    download.editionType = args.input.editionType
    download.format = args.input.format
    download.source = args.input.source
    download.isMobile = args.input.isMobile
    download.audioQuality = args.input.audioQuality
    download.audioPartNumber = args.input.audioPartNumber
    download.userAgent = args.input.userAgent
    download.os = args.input.os
    download.browser = args.input.browser
    download.platform = args.input.platform
    download.referrer = args.input.referrer
    download.ip = args.input.ip
    download.city = args.input.city
    download.region = args.input.region
    download.postalCode = args.input.postalCode
    download.country = args.input.country
    download.latitude = args.input.latitude
    download.longitude = args.input.longitude
    return download.create(on: request.db).map { download }
  }
}
