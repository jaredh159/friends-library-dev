// auto-generated, do not edit
import GraphQL

@testable import App

extension Isbn {
  static var mock: Isbn {
    Isbn(code: .init(rawValue: "@mock code"), editionId: nil)
  }

  static var empty: Isbn {
    Isbn(code: .init(rawValue: ""), editionId: nil)
  }

  static var random: Isbn {
    Isbn(
      code: .init(rawValue: "@random".random),
      editionId: Bool.random() ? .init() : nil
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "code": .string(code.rawValue),
      "editionId": editionId != nil ? .string(editionId!.rawValue.uuidString) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
