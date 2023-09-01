import PairQL

extension CodegenRoute.Dev: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] { [] }
  static var pairqlPairs: [any Pair.Type] {
    [
      CreateArtifactProductionVersion.self,
      LatestArtifactProductionVersion.self,
    ]
  }
}
