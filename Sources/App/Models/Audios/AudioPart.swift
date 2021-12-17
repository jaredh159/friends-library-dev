import Fluent
import Foundation
import NonEmpty
import Tagged
import TaggedTime

final class AudioPart {
  var id: Id
  var audioId: Audio.Id
  var title: String
  var duration: Seconds<Double>
  var chapters: NonEmpty<[Int]>
  var order: Int
  var mp3SizeHq: Bytes
  var mp3SizeLq: Bytes
  var externalIdHq: ExternalId
  var externalIdLq: ExternalId
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var audio = Parent<Audio>.notLoaded

  init(
    id: Id = .init(),
    audioId: Audio.Id,
    title: String,
    duration: Seconds<Double>,
    chapters: NonEmpty<[Int]>,
    order: Int,
    mp3SizeHq: Bytes,
    mp3SizeLq: Bytes,
    externalIdHq: ExternalId,
    externalIdLq: ExternalId
  ) {
    self.id = id
    self.audioId = audioId
    self.title = title
    self.duration = duration
    self.chapters = chapters
    self.order = order
    self.mp3SizeHq = mp3SizeHq
    self.mp3SizeLq = mp3SizeLq
    self.externalIdHq = externalIdHq
    self.externalIdLq = externalIdLq
  }

}

// extensions

extension AudioPart: AppModel {
  typealias Id = Tagged<AudioPart, UUID>
  typealias ExternalId = Tagged<Audio, Int64>
}

extension AudioPart: DuetModel {
  static let tableName = M20.tableName
}

extension AudioPart: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case audioId
    case title
    case duration
    case chapters
    case order
    case mp3SizeHq
    case mp3SizeLq
    case externalIdHq
    case externalIdLq
    case createdAt
    case updatedAt
  }
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
