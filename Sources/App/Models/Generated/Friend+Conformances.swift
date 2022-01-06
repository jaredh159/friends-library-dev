// auto-generated, do not edit
import Foundation
import Tagged

extension Friend: AppModel {
  typealias Id = Tagged<Friend, UUID>
}

extension Friend: DuetModel {
  static let tableName = M11.tableName
}

extension Friend {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.lang]: .enum(lang),
      Self[.name]: .string(name),
      Self[.slug]: .string(slug),
      Self[.gender]: .enum(gender),
      Self[.description]: .string(description),
      Self[.born]: .int(born),
      Self[.died]: .int(died),
      Self[.published]: .date(published),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension Friend {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
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

extension Friend: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "lang":
        return .enum(lang) == constraint.value
      case "name":
        return .string(name) == constraint.value
      case "slug":
        return .string(slug) == constraint.value
      case "gender":
        return .enum(gender) == constraint.value
      case "description":
        return .string(description) == constraint.value
      case "born":
        return .int(born) == constraint.value
      case "died":
        return .int(died) == constraint.value
      case "published":
        return .date(published) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension Friend: Auditable {}
extension Friend: Touchable {}
