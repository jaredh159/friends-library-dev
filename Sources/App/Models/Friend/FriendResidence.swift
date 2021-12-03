import Fluent
import Foundation
import Vapor

final class FriendResidence: Model, Content {
  static let schema = M11.tableName

  struct Duration: Codable {
    var start: Int
    var end: Int
  }

  @ID(key: .id)
  var id: UUID?

  @Field(key: M11.city)
  var city: String

  @Field(key: M11.region)
  var region: String

  @OptionalField(key: M11.duration)
  var duration: Duration?

  @Parent(key: M11.friendId)
  var friend: Friend

  @Timestamp(key: FieldKey.createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: FieldKey.updatedAt, on: .update)
  var updatedAt: Date?

  init() {}
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
