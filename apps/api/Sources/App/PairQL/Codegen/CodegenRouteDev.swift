import PairQL

extension CodegenRoute.Dev: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] { [] }
  static var pairqlPairs: [any Pair.Type] {
    [
      EditorDocumentMap.self,
      CreateArtifactProductionVersion.self,
      LatestArtifactProductionVersion.self,
      GetAudios.self,
      UpdateAudio.self,
      UpdateAudioPart.self,
    ]
  }
}
