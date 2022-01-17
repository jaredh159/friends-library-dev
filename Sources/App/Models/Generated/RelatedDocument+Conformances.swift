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
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case description
    case documentId
    case parentDocumentId
    case createdAt
    case updatedAt
  }
}

extension RelatedDocument {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .description: .string(description),
      .documentId: .uuid(documentId),
      .parentDocumentId: .uuid(parentDocumentId),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension RelatedDocument: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<RelatedDocument>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .description:
        return .string(description) == constraint.value
      case .documentId:
        return .uuid(documentId) == constraint.value
      case .parentDocumentId:
        return .uuid(parentDocumentId) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension RelatedDocument: Auditable {}
extension RelatedDocument: Touchable {}
