// auto-generated, do not edit
import Foundation
import Tagged

extension Download: ApiModel {
  typealias Id = Tagged<Download, UUID>
}

extension Download: DuetModel {
  static let tableName = M1.tableName
  static var isSoftDeletable: Bool { false }
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

extension Download: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Download>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .editionId:
        return constraint.isSatisfiedBy(.uuid(editionId))
      case .format:
        return constraint.isSatisfiedBy(.enum(format))
      case .source:
        return constraint.isSatisfiedBy(.enum(source))
      case .audioQuality:
        return constraint.isSatisfiedBy(.enum(audioQuality))
      case .audioPartNumber:
        return constraint.isSatisfiedBy(.int(audioPartNumber))
      case .isMobile:
        return constraint.isSatisfiedBy(.bool(isMobile))
      case .userAgent:
        return constraint.isSatisfiedBy(.string(userAgent))
      case .os:
        return constraint.isSatisfiedBy(.string(os))
      case .browser:
        return constraint.isSatisfiedBy(.string(browser))
      case .platform:
        return constraint.isSatisfiedBy(.string(platform))
      case .referrer:
        return constraint.isSatisfiedBy(.string(referrer))
      case .ip:
        return constraint.isSatisfiedBy(.string(ip))
      case .city:
        return constraint.isSatisfiedBy(.string(city))
      case .region:
        return constraint.isSatisfiedBy(.string(region))
      case .postalCode:
        return constraint.isSatisfiedBy(.string(postalCode))
      case .country:
        return constraint.isSatisfiedBy(.string(country))
      case .latitude:
        return constraint.isSatisfiedBy(.string(latitude))
      case .longitude:
        return constraint.isSatisfiedBy(.string(longitude))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension Download: Auditable {}
