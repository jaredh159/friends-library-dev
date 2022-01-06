// auto-generated, do not edit
import Foundation
import Tagged

extension Document: AppModel {
  typealias Id = Tagged<Document, UUID>
}

extension Document: DuetModel {
  static let tableName = M14.tableName
}

extension Document {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendId]: .uuid(friendId),
      Self[.altLanguageId]: .uuid(altLanguageId),
      Self[.title]: .string(title),
      Self[.slug]: .string(slug),
      Self[.filename]: .string(filename),
      Self[.published]: .int(published),
      Self[.originalTitle]: .string(originalTitle),
      Self[.incomplete]: .bool(incomplete),
      Self[.description]: .string(description),
      Self[.partialDescription]: .string(partialDescription),
      Self[.featuredDescription]: .string(featuredDescription),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension Document {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case altLanguageId
    case title
    case slug
    case filename
    case published
    case originalTitle
    case incomplete
    case description
    case partialDescription
    case featuredDescription
    case createdAt
    case updatedAt
    case deletedAt
  }
}

extension Document: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "friend_id":
        return .uuid(friendId) == constraint.value
      case "alt_language_id":
        return .uuid(altLanguageId) == constraint.value
      case "title":
        return .string(title) == constraint.value
      case "slug":
        return .string(slug) == constraint.value
      case "filename":
        return .string(filename) == constraint.value
      case "published":
        return .int(published) == constraint.value
      case "original_title":
        return .string(originalTitle) == constraint.value
      case "incomplete":
        return .bool(incomplete) == constraint.value
      case "description":
        return .string(description) == constraint.value
      case "partial_description":
        return .string(partialDescription) == constraint.value
      case "featured_description":
        return .string(featuredDescription) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      case "deleted_at":
        return .date(deletedAt) == constraint.value
      default:
        return false
    }
  }
}

extension Document: Auditable {}
extension Document: Touchable {}
