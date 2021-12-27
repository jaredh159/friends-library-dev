import Foundation

final class FriendResidence: Codable {
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

    var jsonString: String? {
      try? String(data: JSONEncoder().encode(self), encoding: .utf8)
    }
  }
}
