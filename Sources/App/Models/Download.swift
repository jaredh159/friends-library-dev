import Fluent
import Vapor

final class Download: Model, Content {
  static let schema = "downloads"

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

  @ID(key: .id)
  var id: UUID?

  @Field(key: "document_id")
  var documentId: UUID

  @Enum(key: "edition_type")
  var editionType: EditionType

  @Enum(key: "format")
  var format: Format

  @Enum(key: "source")
  var source: DownloadSource

  @OptionalEnum(key: "audio_quality")
  var audioQuality: AudioQuality?

  @OptionalField(key: "audio_part_number")
  var audioPartNumber: Int?

  @Field(key: "is_mobile")
  var isMobile: Bool

  @OptionalField(key: "user_agent")
  var userAgent: String?

  @OptionalField(key: "os")
  var os: String?

  @OptionalField(key: "browser")
  var browser: String?

  @OptionalField(key: "platform")
  var platform: String?

  @OptionalField(key: "referrer")
  var referrer: String?

  @OptionalField(key: "ip")
  var ip: String?

  @OptionalField(key: "city")
  var city: String?

  @OptionalField(key: "region")
  var region: String?

  @OptionalField(key: "postal_code")
  var postalCode: String?

  @OptionalField(key: "country")
  var country: String?

  @OptionalField(key: "latitude")
  var latitude: String?

  @OptionalField(key: "longitude")
  var longitude: String?

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  init() {}
}

extension Download {
  enum M1 {
    enum EditionTypeEnum {
      static let name = "edition_type"
      static let caseUpdated = "updated"
      static let caseModernized = "modernized"
      static let caseOriginal = "original"
    }
  }
}
