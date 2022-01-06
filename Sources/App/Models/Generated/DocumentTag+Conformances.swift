// auto-generated, do not edit
import Foundation
import Tagged

extension DocumentTag: AppModel {
  typealias Id = Tagged<DocumentTag, UUID>
}

extension DocumentTag: DuetModel {
  static let tableName = M15.tableName
}

extension DocumentTag {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.documentId]: .uuid(documentId),
      Self[.type]: .enum(type),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension DocumentTag {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case documentId
    case type
    case createdAt
  }
}

extension DocumentTag: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "document_id":
        return .uuid(documentId) == constraint.value
      case "type":
        return .enum(type) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension DocumentTag: Auditable {}
