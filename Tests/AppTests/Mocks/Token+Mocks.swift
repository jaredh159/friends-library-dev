// auto-generated, do not edit
import GraphQL

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

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "value": .string(value.rawValue.uuidString),
      "description": .string(description),
      "uses": uses != nil ? .number(Number(uses!)) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
