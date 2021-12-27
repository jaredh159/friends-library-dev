// auto-generated, do not edit
import Foundation
import Tagged

extension FriendQuote: AppModel {
  typealias Id = Tagged<FriendQuote, UUID>
}

extension FriendQuote: DuetModel {
  static let tableName = M12.tableName
}

extension FriendQuote {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case source
    case order
    case context
    case createdAt
    case updatedAt
  }
}

extension FriendQuote: Auditable {}
extension FriendQuote: Touchable {}
