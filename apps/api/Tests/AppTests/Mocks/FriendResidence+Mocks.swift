@testable import App

extension FriendResidence {
  static var mock: FriendResidence {
    FriendResidence(friendId: .init(), city: "@mock city", region: "@mock region")
  }

  static var empty: FriendResidence {
    FriendResidence(friendId: .init(), city: "", region: "")
  }

  static var random: FriendResidence {
    FriendResidence(friendId: .init(), city: "@random".random, region: "@random".random)
  }
}
