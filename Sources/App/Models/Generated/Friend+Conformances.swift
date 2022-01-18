// auto-generated, do not edit
import Foundation
import Tagged

extension Friend: AppModel {
  typealias Id = Tagged<Friend, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .friend(Self.self)
  }
}

extension Friend: DuetModel {
  static let tableName = M11.tableName
}

extension Friend {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case lang
    case name
    case slug
    case gender
    case description
    case born
    case died
    case published
    case createdAt
    case updatedAt
  }
}

extension Friend {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .lang: .enum(lang),
      .name: .string(name),
      .slug: .string(slug),
      .gender: .enum(gender),
      .description: .string(description),
      .born: .int(born),
      .died: .int(died),
      .published: .date(published),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Friend: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Friend>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .lang:
        return .enum(lang) == constraint.value
      case .name:
        return .string(name) == constraint.value
      case .slug:
        return .string(slug) == constraint.value
      case .gender:
        return .enum(gender) == constraint.value
      case .description:
        return .string(description) == constraint.value
      case .born:
        return .int(born) == constraint.value
      case .died:
        return .int(died) == constraint.value
      case .published:
        return .date(published) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension Friend: Auditable {}
extension Friend: Touchable {}
