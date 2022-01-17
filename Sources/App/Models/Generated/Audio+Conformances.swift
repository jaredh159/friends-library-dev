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
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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

extension Audio {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .editionId: .uuid(editionId),
      .reader: .string(reader),
      .isIncomplete: .bool(isIncomplete),
      .mp3ZipSizeHq: .int(mp3ZipSizeHq.rawValue),
      .mp3ZipSizeLq: .int(mp3ZipSizeLq.rawValue),
      .m4bSizeHq: .int(m4bSizeHq.rawValue),
      .m4bSizeLq: .int(m4bSizeLq.rawValue),
      .externalPlaylistIdHq: .int64(externalPlaylistIdHq?.rawValue),
      .externalPlaylistIdLq: .int64(externalPlaylistIdLq?.rawValue),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Audio: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Audio>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .editionId:
        return .uuid(editionId) == constraint.value
      case .reader:
        return .string(reader) == constraint.value
      case .isIncomplete:
        return .bool(isIncomplete) == constraint.value
      case .mp3ZipSizeHq:
        return .int(mp3ZipSizeHq.rawValue) == constraint.value
      case .mp3ZipSizeLq:
        return .int(mp3ZipSizeLq.rawValue) == constraint.value
      case .m4bSizeHq:
        return .int(m4bSizeHq.rawValue) == constraint.value
      case .m4bSizeLq:
        return .int(m4bSizeLq.rawValue) == constraint.value
      case .externalPlaylistIdHq:
        return .int64(externalPlaylistIdHq?.rawValue) == constraint.value
      case .externalPlaylistIdLq:
        return .int64(externalPlaylistIdLq?.rawValue) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension Audio: Auditable {}
extension Audio: Touchable {}
