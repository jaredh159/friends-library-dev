import Fluent
import Foundation
import NonEmpty
import Tagged
import TaggedTime
import Vapor

final class AudioPart: Model, Content {
  static let schema = M20.tableName
  typealias ExternalId = Tagged<Audio, Int64>

  @ID(key: .id)
  var id: UUID?

  // @Parent(key: M20.audioId)
  // var audio: Audio

  @Field(key: M20.title)
  var title: String

  @Field(key: M20.duration)
  var duration: Seconds<Double>

  @Field(key: M20.chapters)
  var chapters: NonEmpty<[Int]>

  @Field(key: M20.order)
  var order: Int

  @Field(key: M20.mp3SizeHq)
  var mp3SizeHq: Bytes

  @Field(key: M20.mp3SizeLq)
  var mp3SizeLq: Bytes

  @Field(key: M20.externalIdHq)
  var externalIdHq: ExternalId

  @Field(key: M20.externalIdLq)
  var externalIdLq: ExternalId

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?
}

extension AudioPart {
  enum M20 {
    static let tableName = "edition_audio_parts"
    static let audioId = FieldKey("audio_id")
    static let title = FieldKey("title")
    static let order = FieldKey("order")
    static let duration = FieldKey("duration")
    static let mp3SizeHq = FieldKey("mp3_size_hq")
    static let mp3SizeLq = FieldKey("mp3_size_lq")
    static let externalIdHq = FieldKey("external_id_hq")
    static let externalIdLq = FieldKey("external_id_lq")
    static let chapters = FieldKey("chapters")
  }
}
