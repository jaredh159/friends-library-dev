// auto-generated, do not edit
import Foundation
import Tagged

extension Audio: AppModel {
  typealias Id = Tagged<Audio, UUID>
}

extension Audio: DuetModel {
  static let tableName = M19.tableName
}

extension Audio {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case editionId
    case reader
    case isIncomplete
    case mp3ZipSizeHq
    case mp3ZipSizeLq
    case m4bSizeHq
    case m4bSizeLq
    case externalPlaylistIdHq
    case externalPlaylistIdLq
    case createdAt
    case updatedAt
  }
}
