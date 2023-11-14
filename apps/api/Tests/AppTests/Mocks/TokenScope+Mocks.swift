@testable import App

extension TokenScope {
  static var mock: TokenScope {
    TokenScope(tokenId: .init(), scope: .all)
  }

  static var empty: TokenScope {
    TokenScope(tokenId: .init(), scope: .all)
  }

  static var random: TokenScope {
    TokenScope(tokenId: .init(), scope: Scope.allCases.shuffled().first!)
  }
}
