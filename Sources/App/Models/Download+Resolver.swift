import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  struct CreateDownloadArgs: Codable {
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

  func createDownload(
    request: Request,
    args: CreateDownloadArgs
  ) throws -> Future<Download> {
    try request.requirePermission(to: .mutateDownloads)
    let download = Download()
    download.documentId = args.documentId
    download.editionType = args.editionType
    download.format = args.format
    download.source = args.source
    download.isMobile = args.isMobile
    download.audioQuality = args.audioQuality
    download.audioPartNumber = args.audioPartNumber
    download.userAgent = args.userAgent
    download.os = args.os
    download.browser = args.browser
    download.platform = args.platform
    download.referrer = args.referrer
    download.ip = args.ip
    download.city = args.city
    download.region = args.region
    download.postalCode = args.postalCode
    download.country = args.country
    download.latitude = args.latitude
    download.longitude = args.longitude
    return download.create(on: request.db).map { download }
  }
}
