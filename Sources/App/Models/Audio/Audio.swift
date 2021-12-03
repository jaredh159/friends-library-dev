import Fluent
import Foundation
import Tagged
import Vapor

final class Audio: Model, Content {
  static let schema = M19.tableName
  typealias ExternalPlaylistId = Tagged<Audio, Int64>

  @ID(key: .id)
  var id: UUID?

  @Parent(key: M19.editionId)
  var edition: Edition

  @Field(key: M19.reader)
  var reader: String

  @Field(key: M19.isIncomplete)
  var isIncomplete: Bool

  @Field(key: M19.mp3ZipSizeHq)
  var mp3ZipSizeHq: Bytes

  @Field(key: M19.mp3ZipSizeLq)
  var mp3ZipSizeLq: Bytes

  @Field(key: M19.m4bSizeHq)
  var m4bSizeHq: Bytes

  @Field(key: M19.m4bSizeLq)
  var m4bSizeLq: Bytes

  @Field(key: M19.externalPlaylistIdHq)
  var externalPlaylistIdHq: ExternalPlaylistId

  @Field(key: M19.externalPlaylistIdLq)
  var externalPlaylistIdLq: ExternalPlaylistId

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?
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
