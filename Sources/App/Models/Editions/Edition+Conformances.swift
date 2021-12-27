// auto-generated, do not edit
import Foundation
import Tagged

extension Edition: AppModel {
  typealias Id = Tagged<Edition, UUID>
}

extension Edition: DuetModel {
  static let tableName = "editions"
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
