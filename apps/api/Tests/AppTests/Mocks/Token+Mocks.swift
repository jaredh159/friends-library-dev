@testable import App

extension App.Token {
  static var mock: App.Token {
    Token(description: "@mock description")
  }

  static var empty: App.Token {
    Token(description: "")
  }

  static var random: App.Token {
    Token(description: "@random".random)
  }
}
