// auto-generated, do not edit
@testable import App

extension FriendQuote {
  static var mock: FriendQuote {
    FriendQuote(friendId: .init(), source: "@mock source", order: 42)
  }

  static var empty: FriendQuote {
    FriendQuote(friendId: .init(), source: "", order: 0)
  }

  static var random: FriendQuote {
    FriendQuote(friendId: .init(), source: "@random".random, order: Int.random)
  }
}
