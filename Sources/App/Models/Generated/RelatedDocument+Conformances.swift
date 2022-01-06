// auto-generated, do not edit
import Foundation
import Tagged

extension RelatedDocument: AppModel {
  typealias Id = Tagged<RelatedDocument, UUID>
}

extension RelatedDocument: DuetModel {
  static let tableName = M23.tableName
}

extension RelatedDocument {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.description]: .string(description),
      Self[.documentId]: .uuid(documentId),
      Self[.parentDocumentId]: .uuid(parentDocumentId),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension RelatedDocument {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case description
    case documentId
    case parentDocumentId
    case createdAt
    case updatedAt
  }
}

extension RelatedDocument: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "description":
        return .string(description) == constraint.value
      case "document_id":
        return .uuid(documentId) == constraint.value
      case "parent_document_id":
        return .uuid(parentDocumentId) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension RelatedDocument: Auditable {}
extension RelatedDocument: Touchable {}
