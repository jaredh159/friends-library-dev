import DuetSQL
import Foundation
import PairQL
import Vapor

enum NextEvansBuildRoute: PairRoute {
  case authed(UUID, AuthedNextEvansBuildRoute)

  static let router = OneOf {
    Route(/Self.authed) {
      Headers {
        Field("Authorization") {
          Skip { "Bearer " }
          UUID.parser()
        }
      }
      AuthedNextEvansBuildRoute.router
    }
  }
}

enum AuthedNextEvansBuildRoute: PairRoute {
  case documentPage(DocumentPage.Input)
  case explorePageBooks(Lang)
  case friendPage(FriendPage.Input)
  case friendsPage(Lang)
  case gettingStartedBooks(GettingStartedBooks.Input)
  case homepageFeaturedBooks(HomepageFeaturedBooks.Input)
  case newsFeedItems(NewsFeedItems.Input)
  case publishedDocumentSlugs(PublishedDocumentSlugs.Input)
  case publishedFriendSlugs(Lang)
  case totalPublished

  static let router: AnyParserPrinter<URLRequestData, AuthedNextEvansBuildRoute> = OneOf {
    Route(/Self.documentPage) {
      Operation(DocumentPage.self)
      Body(.input(DocumentPage.self))
    }
    Route(/Self.explorePageBooks) {
      Operation(ExplorePageBooks.self)
      Body(.input(ExplorePageBooks.self))
    }
    Route(/Self.friendPage) {
      Operation(FriendPage.self)
      Body(.input(FriendPage.self))
    }
    Route(/Self.friendsPage) {
      Operation(FriendsPage.self)
      Body(.input(FriendsPage.self))
    }
    Route(/Self.gettingStartedBooks) {
      Operation(GettingStartedBooks.self)
      Body(.input(GettingStartedBooks.self))
    }
    Route(/Self.homepageFeaturedBooks) {
      Operation(HomepageFeaturedBooks.self)
      Body(.input(HomepageFeaturedBooks.self))
    }
    Route(/Self.newsFeedItems) {
      Operation(NewsFeedItems.self)
      Body(.input(NewsFeedItems.self))
    }
    Route(/Self.publishedDocumentSlugs) {
      Operation(PublishedDocumentSlugs.self)
      Body(.input(PublishedDocumentSlugs.self))
    }
    Route(/Self.publishedFriendSlugs) {
      Operation(PublishedFriendSlugs.self)
      Body(.input(PublishedFriendSlugs.self))
    }
    Route(/Self.totalPublished) {
      Operation(TotalPublished.self)
    }
  }
  .eraseToAnyParserPrinter()
}

extension NextEvansBuildRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .authed(let token, let authedRoute):
      let token = try await Token.query().where(.value == token).first()
      let authed = AuthedContext(requestId: context.requestId, scopes: try await token.scopes())
      switch authedRoute {
      case .documentPage(let input):
        let output = try await DocumentPage.resolve(with: input, in: authed)
        return try respond(with: output)
      case .explorePageBooks(let lang):
        let output = try await ExplorePageBooks.resolve(with: lang, in: authed)
        return try respond(with: output)
      case .friendPage(let input):
        let output = try await FriendPage.resolve(with: input, in: authed)
        return try respond(with: output)
      case .friendsPage(let lang):
        let output = try await FriendsPage.resolve(with: lang, in: authed)
        return try respond(with: output)
      case .gettingStartedBooks(let input):
        let output = try await GettingStartedBooks.resolve(with: input, in: authed)
        return try respond(with: output)
      case .homepageFeaturedBooks(let input):
        let output = try await HomepageFeaturedBooks.resolve(with: input, in: authed)
        return try respond(with: output)
      case .newsFeedItems(let input):
        let output = try await NewsFeedItems.resolve(with: input, in: authed)
        return try respond(with: output)
      case .publishedFriendSlugs(let lang):
        let output = try await PublishedFriendSlugs.resolve(with: lang, in: authed)
        return try respond(with: output)
      case .publishedDocumentSlugs(let input):
        let output = try await PublishedDocumentSlugs.resolve(with: input, in: authed)
        return try respond(with: output)
      case .totalPublished:
        let output = try await TotalPublished.resolve(in: authed)
        return try respond(with: output)
      }
    }
  }
}
