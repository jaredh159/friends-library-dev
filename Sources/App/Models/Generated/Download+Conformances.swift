// auto-generated, do not edit
import Foundation
import Tagged

extension Download: AppModel {
  typealias Id = Tagged<Download, UUID>
}

extension Download: DuetModel {
  static let tableName = M1.tableName
}

extension Download {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.editionId]: .uuid(editionId),
      Self[.format]: .enum(format),
      Self[.source]: .enum(source),
      Self[.audioQuality]: .enum(audioQuality),
      Self[.audioPartNumber]: .int(audioPartNumber),
      Self[.isMobile]: .bool(isMobile),
      Self[.userAgent]: .string(userAgent),
      Self[.os]: .string(os),
      Self[.browser]: .string(browser),
      Self[.platform]: .string(platform),
      Self[.referrer]: .string(referrer),
      Self[.ip]: .string(ip),
      Self[.city]: .string(city),
      Self[.region]: .string(region),
      Self[.postalCode]: .string(postalCode),
      Self[.country]: .string(country),
      Self[.latitude]: .string(latitude),
      Self[.longitude]: .string(longitude),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension Download {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case editionId
    case format
    case source
    case audioQuality
    case audioPartNumber
    case isMobile
    case userAgent
    case os
    case browser
    case platform
    case referrer
    case ip
    case city
    case region
    case postalCode
    case country
    case latitude
    case longitude
    case createdAt
  }
}

extension Download: Auditable {}
