// auto-generated, do not edit
import Foundation
import Tagged

extension FriendResidence: AppModel {
  typealias Id = Tagged<FriendResidence, UUID>
}

extension FriendResidence: DuetModel {
  static let tableName = M11.tableName
}

extension FriendResidence {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case city
    case region
    case duration
    case createdAt
    case updatedAt
  }
}

extension FriendResidence: Auditable {}
extension FriendResidence: Touchable {}
