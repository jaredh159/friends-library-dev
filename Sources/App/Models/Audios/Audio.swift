import Fluent
import Foundation
import Tagged

final class Audio {
  var id: Id
  var editionId: Edition.Id
  var reader: String
  var isIncomplete: Bool
  var mp3ZipSizeHq: Bytes
  var mp3ZipSizeLq: Bytes
  var m4bSizeHq: Bytes
  var m4bSizeLq: Bytes
  var externalPlaylistIdHq: ExternalPlaylistId?
  var externalPlaylistIdLq: ExternalPlaylistId?
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var edition = Parent<Edition>.notLoaded

  init(
    id: Id = .init(),
    editionId: Edition.Id,
    reader: String,
    mp3ZipSizeHq: Bytes,
    mp3ZipSizeLq: Bytes,
    m4bSizeHq: Bytes,
    m4bSizeLq: Bytes,
    externalPlaylistIdHq: ExternalPlaylistId? = nil,
    externalPlaylistIdLq: ExternalPlaylistId? = nil,
    isIncomplete: Bool = false
  ) {
    self.id = id
    self.editionId = editionId
    self.reader = reader
    self.mp3ZipSizeHq = mp3ZipSizeHq
    self.mp3ZipSizeLq = mp3ZipSizeLq
    self.m4bSizeHq = m4bSizeHq
    self.m4bSizeLq = m4bSizeLq
    self.externalPlaylistIdHq = externalPlaylistIdHq
    self.externalPlaylistIdLq = externalPlaylistIdLq
    self.isIncomplete = isIncomplete
  }
}

// extensions

extension Audio: AppModel {
  typealias Id = Tagged<Audio, UUID>
  typealias ExternalPlaylistId = Tagged<Audio, Int64>
}

extension Audio: DuetModel {
  static let tableName = M19.tableName
}

extension Audio: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case editionId
    case reader
    case mp3ZipSizeHq
    case mp3ZipSizeLq
    case m4bSizeHq
    case m4bSizeLq
    case externalPlaylistIdHq
    case externalPlaylistIdLq
    case isIncomplete
    case createdAt
    case updatedAt
  }
}

extension Audio {
  enum M19 {
    static let tableName = "edition_audios"
    static let editionId = FieldKey("edition_id")
    static let reader = FieldKey("reader")
    static let isIncomplete = FieldKey("is_incomplete")
    static let mp3ZipSizeHq = FieldKey("mp3_zip_size_hq")
    static let mp3ZipSizeLq = FieldKey("mp3_zip_size_lq")
    static let m4bSizeHq = FieldKey("m4b_size_hq")
    static let m4bSizeLq = FieldKey("m4b_size_lq")
    static let externalPlaylistIdHq = FieldKey("external_playlist_id_hq")
    static let externalPlaylistIdLq = FieldKey("external_playlist_id_lq")
  }
}
