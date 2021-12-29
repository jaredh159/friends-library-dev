// auto-generated, do not edit
import Foundation
import Tagged

extension AudioPart: AppModel {
  typealias Id = Tagged<AudioPart, UUID>
}

extension AudioPart: DuetModel {
  static let tableName = M20.tableName
}

extension AudioPart {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.audioId]: .uuid(audioId),
      Self[.title]: .string(title),
      Self[.duration]: .double(duration.rawValue),
      Self[.chapters]: .intArray(chapters.array),
      Self[.order]: .int(order),
      Self[.mp3SizeHq]: .int(mp3SizeHq.rawValue),
      Self[.mp3SizeLq]: .int(mp3SizeLq.rawValue),
      Self[.externalIdHq]: .int64(externalIdHq.rawValue),
      Self[.externalIdLq]: .int64(externalIdLq.rawValue),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension AudioPart {
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

extension AudioPart: Auditable {}
extension AudioPart: Touchable {}
