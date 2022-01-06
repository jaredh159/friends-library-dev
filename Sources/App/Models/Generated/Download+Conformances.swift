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

extension Download: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "editionId":
        return .uuid(editionId) == constraint.value
      case "format":
        return .enum(format) == constraint.value
      case "source":
        return .enum(source) == constraint.value
      case "audioQuality":
        return .enum(audioQuality) == constraint.value
      case "audioPartNumber":
        return .int(audioPartNumber) == constraint.value
      case "isMobile":
        return .bool(isMobile) == constraint.value
      case "userAgent":
        return .string(userAgent) == constraint.value
      case "os":
        return .string(os) == constraint.value
      case "browser":
        return .string(browser) == constraint.value
      case "platform":
        return .string(platform) == constraint.value
      case "referrer":
        return .string(referrer) == constraint.value
      case "ip":
        return .string(ip) == constraint.value
      case "city":
        return .string(city) == constraint.value
      case "region":
        return .string(region) == constraint.value
      case "postalCode":
        return .string(postalCode) == constraint.value
      case "country":
        return .string(country) == constraint.value
      case "latitude":
        return .string(latitude) == constraint.value
      case "longitude":
        return .string(longitude) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension Download: Auditable {}
