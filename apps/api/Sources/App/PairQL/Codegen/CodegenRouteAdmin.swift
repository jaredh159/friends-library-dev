import PairQL

extension CodegenRoute.Admin: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    []
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      ListFriends.self,
    ]
  }
}
