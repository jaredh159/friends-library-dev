import PairQL

extension CodegenRoute.EvansBuild: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    []
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      GetFriends.self,
      GetDocumentDownloadCounts.self,
    ]
  }
}
