// auto-generated, do not edit
import DuetSQL
import Tagged

extension AudioPart: ApiModel {
  typealias Id = Tagged<AudioPart, UUID>
}

extension AudioPart: Model {
  static let tableName = M21.tableName
  static var isSoftDeletable: Bool { false }
}

extension AudioPart {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .audioId: .uuid(audioId),
      .title: .string(title),
      .duration: .double(duration.rawValue),
      .chapters: .intArray(chapters.array),
      .order: .int(order),
      .mp3SizeHq: .int(mp3SizeHq.rawValue),
      .mp3SizeLq: .int(mp3SizeLq.rawValue),
      .externalIdHq: .int64(externalIdHq.rawValue),
      .externalIdLq: .int64(externalIdLq.rawValue),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension AudioPart: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<AudioPart>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .audioId:
        return constraint.isSatisfiedBy(.uuid(audioId))
      case .title:
        return constraint.isSatisfiedBy(.string(title))
      case .duration:
        return constraint.isSatisfiedBy(.double(duration.rawValue))
      case .chapters:
        return constraint.isSatisfiedBy(.intArray(chapters.array))
      case .order:
        return constraint.isSatisfiedBy(.int(order))
      case .mp3SizeHq:
        return constraint.isSatisfiedBy(.int(mp3SizeHq.rawValue))
      case .mp3SizeLq:
        return constraint.isSatisfiedBy(.int(mp3SizeLq.rawValue))
      case .externalIdHq:
        return constraint.isSatisfiedBy(.int64(externalIdHq.rawValue))
      case .externalIdLq:
        return constraint.isSatisfiedBy(.int64(externalIdLq.rawValue))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension AudioPart: Auditable {}
extension AudioPart: Touchable {}
