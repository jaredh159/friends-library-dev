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

extension Download {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .editionId: .uuid(editionId),
      .format: .enum(format),
      .source: .enum(source),
      .audioQuality: .enum(audioQuality),
      .audioPartNumber: .int(audioPartNumber),
      .isMobile: .bool(isMobile),
      .userAgent: .string(userAgent),
      .os: .string(os),
      .browser: .string(browser),
      .platform: .string(platform),
      .referrer: .string(referrer),
      .ip: .string(ip),
      .city: .string(city),
      .region: .string(region),
      .postalCode: .string(postalCode),
      .country: .string(country),
      .latitude: .string(latitude),
      .longitude: .string(longitude),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension Download: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "edition_id":
        return .uuid(editionId) == constraint.value
      case "format":
        return .enum(format) == constraint.value
      case "source":
        return .enum(source) == constraint.value
      case "audio_quality":
        return .enum(audioQuality) == constraint.value
      case "audio_part_number":
        return .int(audioPartNumber) == constraint.value
      case "is_mobile":
        return .bool(isMobile) == constraint.value
      case "user_agent":
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
      case "postal_code":
        return .string(postalCode) == constraint.value
      case "country":
        return .string(country) == constraint.value
      case "latitude":
        return .string(latitude) == constraint.value
      case "longitude":
        return .string(longitude) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension Download: Auditable {}
