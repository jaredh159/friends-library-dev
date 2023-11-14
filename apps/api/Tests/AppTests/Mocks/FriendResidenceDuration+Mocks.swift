@testable import App

extension FriendResidenceDuration {
  static var mock: FriendResidenceDuration {
    FriendResidenceDuration(friendResidenceId: .init(), start: 42, end: 42)
  }

  static var empty: FriendResidenceDuration {
    FriendResidenceDuration(friendResidenceId: .init(), start: 0, end: 0)
  }

  static var random: FriendResidenceDuration {
    FriendResidenceDuration(friendResidenceId: .init(), start: Int.random, end: Int.random)
  }
}
