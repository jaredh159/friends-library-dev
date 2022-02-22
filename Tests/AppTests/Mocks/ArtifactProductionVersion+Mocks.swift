// auto-generated, do not edit
import GraphQL

@testable import App

extension ArtifactProductionVersion {
  static var mock: ArtifactProductionVersion {
    ArtifactProductionVersion(version: "@mock version")
  }

  static var empty: ArtifactProductionVersion {
    ArtifactProductionVersion(version: "")
  }

  static var random: ArtifactProductionVersion {
    ArtifactProductionVersion(version: .init(rawValue: "@random".random))
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "version": .string(version.rawValue),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
