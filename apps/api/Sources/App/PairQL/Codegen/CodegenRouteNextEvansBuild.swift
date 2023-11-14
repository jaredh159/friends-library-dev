import PairQL

extension CodegenRoute.NextEvansBuild: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    []
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      FriendsPage.self,
    ]
  }
}
