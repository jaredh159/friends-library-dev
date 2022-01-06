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

extension Audio: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "editionId":
        return .uuid(editionId) == constraint.value
      case "reader":
        return .string(reader) == constraint.value
      case "isIncomplete":
        return .bool(isIncomplete) == constraint.value
      case "mp3ZipSizeHq":
        return .int(mp3ZipSizeHq.rawValue) == constraint.value
      case "mp3ZipSizeLq":
        return .int(mp3ZipSizeLq.rawValue) == constraint.value
      case "m4bSizeHq":
        return .int(m4bSizeHq.rawValue) == constraint.value
      case "m4bSizeLq":
        return .int(m4bSizeLq.rawValue) == constraint.value
      case "externalPlaylistIdHq":
        return .int64(externalPlaylistIdHq?.rawValue) == constraint.value
      case "externalPlaylistIdLq":
        return .int64(externalPlaylistIdLq?.rawValue) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      case "updatedAt":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension Audio: Auditable {}
extension Audio: Touchable {}
