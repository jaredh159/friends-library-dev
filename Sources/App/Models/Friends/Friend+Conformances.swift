// auto-generated, do not edit
import Foundation
import Tagged

extension Friend: AppModel {
  typealias Id = Tagged<Friend, UUID>
}

extension Friend: DuetModel {
  static let tableName = M10.tableName
}

extension Friend {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case lang
    case name
    case slug
    case gender
    case description
    case born
    case died
    case published
    case createdAt
    case updatedAt
  }
}
