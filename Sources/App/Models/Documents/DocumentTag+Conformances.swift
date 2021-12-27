// auto-generated, do not edit
import Foundation
import Tagged

extension DocumentTagModel: AppModel {
  typealias Id = Tagged<DocumentTagModel, UUID>
}

extension DocumentTagModel: DuetModel {
  static let tableName = M14.tableName
}

extension DocumentTagModel {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case slug
    case createdAt
  }
}
