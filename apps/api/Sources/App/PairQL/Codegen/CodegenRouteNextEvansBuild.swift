import PairQL

extension CodegenRoute.NextEvansBuild: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [("DocumentTag", DocumentTag.TagType.self)]
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      DocumentPage.self,
      ExplorePageBooks.self,
      FriendPage.self,
      FriendsPage.self,
      GettingStartedBooks.self,
      HomepageFeaturedBooks.self,
      NewsFeedItems.self,
      PublishedDocumentSlugs.self,
      PublishedFriendSlugs.self,
      TotalPublished.self,
    ]
  }
}
