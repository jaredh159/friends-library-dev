// auto-generated, do not edit
import Foundation
import Tagged

extension FriendResidence: AppModel {
  typealias Id = Tagged<FriendResidence, UUID>
}

extension FriendResidence: DuetModel {
  static let tableName = M11.tableName
}

extension FriendResidence: DuetInsertable {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendId]: .uuid(friendId),
      Self[.city]: .string(city),
      Self[.region]: .string(region),
      Self[.duration]: .json(duration?.jsonString),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
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
