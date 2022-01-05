// auto-generated, do not edit
import Foundation
import Tagged

extension FriendQuote: AppModel {
  typealias Id = Tagged<FriendQuote, UUID>
}

extension FriendQuote: DuetModel {
  static let tableName = M13.tableName
}

extension FriendQuote {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendId]: .uuid(friendId),
      Self[.source]: .string(source),
      Self[.text]: .string(text),
      Self[.order]: .int(order),
      Self[.context]: .string(context),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension FriendQuote {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case source
    case text
    case order
    case context
    case createdAt
    case updatedAt
  }
}

extension FriendQuote: Auditable {}
extension FriendQuote: Touchable {}
