// auto-generated, do not edit
import Foundation
import Tagged

extension Edition: AppModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: DuetModel {
  static let tableName = M16.tableName
}

extension Edition: DuetInsertable {
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

extension Edition: Auditable {}
extension Edition: Touchable {}
