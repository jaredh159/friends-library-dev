// auto-generated, do not edit
import Foundation
import Tagged

extension DocumentTag: ApiModel {
  typealias Id = Tagged<DocumentTag, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .documentTag(Self.self)
  }
}

extension DocumentTag: DuetModel {
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
        return .id(self) == constraint.value
      case .documentId:
        return .uuid(documentId) == constraint.value
      case .type:
        return .enum(type) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
    }
  }
}

extension DocumentTag: Auditable {}
