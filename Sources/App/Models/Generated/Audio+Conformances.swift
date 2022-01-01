// auto-generated, do not edit
import Foundation
import Tagged

extension Audio: AppModel {
  typealias Id = Tagged<Audio, UUID>
}

extension Audio: DuetModel {
  static let tableName = M20.tableName
}

extension Audio {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.editionId]: .uuid(editionId),
      Self[.reader]: .string(reader),
      Self[.isIncomplete]: .bool(isIncomplete),
      Self[.mp3ZipSizeHq]: .int(mp3ZipSizeHq.rawValue),
      Self[.mp3ZipSizeLq]: .int(mp3ZipSizeLq.rawValue),
      Self[.m4bSizeHq]: .int(m4bSizeHq.rawValue),
      Self[.m4bSizeLq]: .int(m4bSizeLq.rawValue),
      Self[.externalPlaylistIdHq]: .int64(externalPlaylistIdHq?.rawValue),
      Self[.externalPlaylistIdLq]: .int64(externalPlaylistIdLq?.rawValue),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
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

extension Audio: Auditable {}
extension Audio: Touchable {}
