import GraphQL

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

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "scope": .string(scope.rawValue),
      "tokenId": .string(tokenId.lowercased),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
