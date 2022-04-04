// auto-generated, do not edit
import DuetSQL
import Tagged

extension RelatedDocument: ApiModel {
  typealias Id = Tagged<RelatedDocument, UUID>
}

extension RelatedDocument: Model {
  static let tableName = M23.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .description:
        return constraint.isSatisfiedBy(.string(description))
      case .documentId:
        return constraint.isSatisfiedBy(.uuid(documentId))
      case .parentDocumentId:
        return constraint.isSatisfiedBy(.uuid(parentDocumentId))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension RelatedDocument: Auditable {}
extension RelatedDocument: Touchable {}
