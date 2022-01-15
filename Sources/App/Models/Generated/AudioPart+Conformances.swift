// auto-generated, do not edit
import Foundation
import Tagged

extension AudioPart: AppModel {
  typealias Id = Tagged<AudioPart, UUID>
}

extension AudioPart: DuetModel {
  static let tableName = M21.tableName
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
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "audio_id":
        return .uuid(audioId) == constraint.value
      case "title":
        return .string(title) == constraint.value
      case "duration":
        return .double(duration.rawValue) == constraint.value
      case "chapters":
        return .intArray(chapters.array) == constraint.value
      case "order":
        return .int(order) == constraint.value
      case "mp3_size_hq":
        return .int(mp3SizeHq.rawValue) == constraint.value
      case "mp3_size_lq":
        return .int(mp3SizeLq.rawValue) == constraint.value
      case "external_id_hq":
        return .int64(externalIdHq.rawValue) == constraint.value
      case "external_id_lq":
        return .int64(externalIdLq.rawValue) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension AudioPart: Auditable {}
extension AudioPart: Touchable {}
