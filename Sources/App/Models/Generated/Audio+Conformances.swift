// auto-generated, do not edit
import DuetSQL
import Tagged

extension Audio: ApiModel {
  typealias Id = Tagged<Audio, UUID>
}

extension Audio: Model {
  static let tableName = M20.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .editionId:
        return constraint.isSatisfiedBy(.uuid(editionId))
      case .reader:
        return constraint.isSatisfiedBy(.string(reader))
      case .isIncomplete:
        return constraint.isSatisfiedBy(.bool(isIncomplete))
      case .mp3ZipSizeHq:
        return constraint.isSatisfiedBy(.int(mp3ZipSizeHq.rawValue))
      case .mp3ZipSizeLq:
        return constraint.isSatisfiedBy(.int(mp3ZipSizeLq.rawValue))
      case .m4bSizeHq:
        return constraint.isSatisfiedBy(.int(m4bSizeHq.rawValue))
      case .m4bSizeLq:
        return constraint.isSatisfiedBy(.int(m4bSizeLq.rawValue))
      case .externalPlaylistIdHq:
        return constraint.isSatisfiedBy(.int64(externalPlaylistIdHq?.rawValue))
      case .externalPlaylistIdLq:
        return constraint.isSatisfiedBy(.int64(externalPlaylistIdLq?.rawValue))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension Audio: Auditable {}
extension Audio: Touchable {}
