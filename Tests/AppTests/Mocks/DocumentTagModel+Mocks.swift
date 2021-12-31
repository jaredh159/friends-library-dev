// auto-generated, do not edit
import GraphQL

@testable import App

extension DocumentTagModel {
  static var mock: DocumentTagModel {
    DocumentTagModel(slug: .journal)
  }

  static var empty: DocumentTagModel {
    DocumentTagModel(slug: .journal)
  }

  static var random: DocumentTagModel {
    DocumentTagModel(slug: DocumentTag.allCases.shuffled().first!)
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "slug": .string(slug.rawValue),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
