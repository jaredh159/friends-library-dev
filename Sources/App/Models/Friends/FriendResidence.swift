import Fluent
import Foundation
import Tagged
import Vapor

final class FriendResidence {
  var id: Id
  var friendId: Friend.Id
  var city: String
  var region: String
  var duration: Duration?
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var friend = Parent<Friend>.notLoaded

  init(
    id: Id = .init(),
    friendId: Friend.Id,
    city: String,
    region: String,
    duration: Duration? = nil
  ) {
    self.id = id
    self.friendId = friendId
    self.city = city
    self.region = region
    self.duration = duration
  }
}

// extensions

extension FriendResidence {
  struct Duration: Codable {
    var start: Int
    var end: Int
  }
}

extension FriendResidence: AppModel {
  typealias Id = Tagged<FriendResidence, UUID>
}

extension FriendResidence: DuetModel {
  static let tableName = M11.tableName
}

extension FriendResidence: Codable {
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

extension FriendResidence {
  enum M11 {
    static let tableName = "friend_residences"
    static let id = FieldKey("id")
    static let city = FieldKey("city")
    static let region = FieldKey("region")
    static let duration = FieldKey("duration")
    static let friendId = FieldKey("friend_id")
  }
}
