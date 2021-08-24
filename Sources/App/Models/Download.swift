import Fluent
import Vapor

enum EditionType: String, Codable {
  case updated
  case original
  case modernized
}

final class Download: Model, Content {
  static let schema = "downloads"

  enum AudioQuality: String, Codable {
    case lq
    case hq
  }

  enum Format: String, Codable {
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

  enum Source: String, Codable {
    case web
    case podcast
    case app
  }

  @ID(key: .id)
  var id: UUID?

  @Field(key: "document_id")
  var documentId: UUID

  @Field(key: "edition_type")
  var editionType: EditionType

  @Field(key: "format")
  var format: Format

  @Field(key: "source")
  var source: Source

  @OptionalEnum(key: "audio_quality")
  var audioQuality: AudioQuality?

  @OptionalField(key: "audio_part_number")
  var audioPartNumber: Int?

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
