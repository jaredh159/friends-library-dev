// auto-generated, do not edit
import DuetSQL
import Tagged

extension DocumentTag: ApiModel {
  typealias Id = Tagged<DocumentTag, UUID>
}

extension DocumentTag: Model {
  static let tableName = M15.tableName
  static var isSoftDeletable: Bool { false }
}

extension DocumentTag {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case documentId
    case type
    case createdAt
  }
}

extension DocumentTag {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .documentId: .uuid(documentId),
      .type: .enum(type),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension DocumentTag: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<DocumentTag>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .documentId:
        return constraint.isSatisfiedBy(.uuid(documentId))
      case .type:
        return constraint.isSatisfiedBy(.enum(type))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension DocumentTag: Auditable {}
