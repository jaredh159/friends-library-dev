// auto-generated, do not edit
import Foundation
import Tagged

extension AudioPart: AppModel {
  typealias Id = Tagged<AudioPart, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .audioPart(Self.self)
  }
}

extension AudioPart: DuetModel {
  static let tableName = M21.tableName
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
        return .id(self) == constraint.value
      case .audioId:
        return .uuid(audioId) == constraint.value
      case .title:
        return .string(title) == constraint.value
      case .duration:
        return .double(duration.rawValue) == constraint.value
      case .chapters:
        return .intArray(chapters.array) == constraint.value
      case .order:
        return .int(order) == constraint.value
      case .mp3SizeHq:
        return .int(mp3SizeHq.rawValue) == constraint.value
      case .mp3SizeLq:
        return .int(mp3SizeLq.rawValue) == constraint.value
      case .externalIdHq:
        return .int64(externalIdHq.rawValue) == constraint.value
      case .externalIdLq:
        return .int64(externalIdLq.rawValue) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension AudioPart: Auditable {}
extension AudioPart: Touchable {}
