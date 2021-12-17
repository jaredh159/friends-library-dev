import Fluent
import Tagged
import Vapor

// @TODO, do a migration to remove DocumentId / EditionType combo, replace with Edition.Id

final class Download {
  var id: Id
  var documentId: Document.Id
  var editionType: EditionType
  var format: Format
  var source: DownloadSource
  var audioQuality: AudioQuality?
  var audioPartNumber: Int?
  var isMobile: Bool
  var userAgent: String?
  var os: String?
  var browser: String?
  var platform: String?
  var referrer: String?
  var ip: String?
  var city: String?
  var region: String?
  var postalCode: String?
  var country: String?
  var latitude: String?
  var longitude: String?
  var createdAt = Current.date()

  init(
    id: Id = .init(),
    documentId: Document.Id,
    editionType: EditionType,
    format: Format,
    source: DownloadSource,
    isMobile: Bool,
    audioQuality: AudioQuality? = nil,
    audioPartNumber: Int? = nil,
    userAgent: String? = nil,
    os: String? = nil,
    browser: String? = nil,
    platform: String? = nil,
    referrer: String? = nil,
    ip: String? = nil,
    city: String? = nil,
    region: String? = nil,
    postalCode: String? = nil,
    country: String? = nil,
    latitude: String? = nil,
    longitude: String? = nil
  ) {
    self.id = id
    self.documentId = documentId
    self.editionType = editionType
    self.format = format
    self.source = source
    self.audioQuality = audioQuality
    self.audioPartNumber = audioPartNumber
    self.isMobile = isMobile
    self.userAgent = userAgent
    self.os = os
    self.browser = browser
    self.platform = platform
    self.referrer = referrer
    self.ip = ip
    self.city = city
    self.region = region
    self.postalCode = postalCode
    self.country = country
    self.latitude = latitude
    self.longitude = longitude
  }

}

// extensions

extension Download {
  enum AudioQuality: String, Codable, CaseIterable {
    case lq
    case hq
  }

  enum Format: String, Codable, CaseIterable {
    case epub
    case mobi
    case webPdf
    case mp3Zip
    case m4b
    case mp3
    case speech
    case podcast
    case appEbook
  }

  enum DownloadSource: String, Codable, CaseIterable {
    case website
    case podcast
    case app
  }
}

extension Download: AppModel {
  typealias Id = Tagged<Download, UUID>
}

extension Download: DuetModel {
  static let tableName = M1.tableName
}

extension Download: Codable {
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

extension Download {
  enum M1 {
    static let tableName = "downloads"
    enum EditionTypeEnum {
      static let name = "edition_type"
      static let caseUpdated = "updated"
      static let caseModernized = "modernized"
      static let caseOriginal = "original"
    }
  }
}

extension EditionType: PostgresEnum {
  var dataType: String {
    Download.M1.EditionTypeEnum.name
  }
}
