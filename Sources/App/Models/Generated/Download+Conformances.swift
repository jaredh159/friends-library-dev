// auto-generated, do not edit
import DuetSQL
import Tagged

extension Download: ApiModel {
  typealias Id = Tagged<Download, UUID>
}

extension Download: Model {
  static let tableName = M1.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .editionId:
        return .uuid(editionId)
      case .format:
        return .enum(format)
      case .source:
        return .enum(source)
      case .audioQuality:
        return .enum(audioQuality)
      case .audioPartNumber:
        return .int(audioPartNumber)
      case .isMobile:
        return .bool(isMobile)
      case .userAgent:
        return .string(userAgent)
      case .os:
        return .string(os)
      case .browser:
        return .string(browser)
      case .platform:
        return .string(platform)
      case .referrer:
        return .string(referrer)
      case .ip:
        return .string(ip)
      case .city:
        return .string(city)
      case .region:
        return .string(region)
      case .postalCode:
        return .string(postalCode)
      case .country:
        return .string(country)
      case .latitude:
        return .string(latitude)
      case .longitude:
        return .string(longitude)
      case .createdAt:
        return .date(createdAt)
    }
  }
}

extension Download {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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
