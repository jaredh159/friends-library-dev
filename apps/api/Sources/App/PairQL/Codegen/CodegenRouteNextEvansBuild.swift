import PairQL

extension CodegenRoute.NextEvansBuild: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [("DocumentTag", DocumentTag.TagType.self)]
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      DocumentPage.self,
      ExplorePage.self,
      FriendPage.self,
      FriendsPage.self,
      PublishedDocumentSlugs.self,
      PublishedFriendSlugs.self,
    ]
  }
}
