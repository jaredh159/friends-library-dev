// auto-generated, do not edit
import Foundation
import Tagged

extension Edition: AppModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: DuetModel {
  static let tableName = M17.tableName
}

extension Edition {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.documentId]: .uuid(documentId),
      Self[.type]: .enum(type),
      Self[.editor]: .string(editor),
      Self[.isDraft]: .bool(isDraft),
      Self[.paperbackSplits]: .intArray(paperbackSplits?.array),
      Self[.paperbackOverrideSize]: .enum(paperbackOverrideSize),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension Edition {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case documentId
    case type
    case editor
    case isDraft
    case paperbackSplits
    case paperbackOverrideSize
    case createdAt
    case updatedAt
    case deletedAt
  }
}

extension Edition: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "document_id":
        return .uuid(documentId) == constraint.value
      case "type":
        return .enum(type) == constraint.value
      case "editor":
        return .string(editor) == constraint.value
      case "is_draft":
        return .bool(isDraft) == constraint.value
      case "paperback_splits":
        return .intArray(paperbackSplits?.array) == constraint.value
      case "paperback_override_size":
        return .enum(paperbackOverrideSize) == constraint.value
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

extension Edition: Auditable {}
extension Edition: Touchable {}
