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
    case documentId
    case editionType
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
