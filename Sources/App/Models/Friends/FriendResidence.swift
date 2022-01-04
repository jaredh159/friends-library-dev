import Foundation

final class FriendResidence: Codable {
  var id: Id
  var friendId: Friend.Id
  var city: String
  var region: String
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var friend = Parent<Friend>.notLoaded
  var durations = Children<FriendResidenceDuration>.notLoaded

  init(id: Id = .init(), friendId: Friend.Id, city: String, region: String) {
    self.id = id
    self.friendId = friendId
    self.city = city
    self.region = region
  }
}
