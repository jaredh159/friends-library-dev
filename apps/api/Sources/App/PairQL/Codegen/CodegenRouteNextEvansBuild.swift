import PairQL

extension CodegenRoute.NextEvansBuild: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [("DocumentTag", DocumentTag.TagType.self)]
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      FriendPage.self,
      FriendsPage.self,
      PublishedFriendSlugs.self,
    ]
  }
}
