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
  case friendPage(FriendPage.Input)
  case friendsPage(Lang)
  case publishedFriendSlugs(Lang)

  static let router: AnyParserPrinter<URLRequestData, AuthedNextEvansBuildRoute> = OneOf {
    Route(/Self.friendPage) {
      Operation(FriendPage.self)
      Body(.input(FriendPage.self))
    }
    Route(/Self.friendsPage) {
      Operation(FriendsPage.self)
      Body(.input(FriendsPage.self))
    }
    Route(/Self.publishedFriendSlugs) {
      Operation(PublishedFriendSlugs.self)
      Body(.input(PublishedFriendSlugs.self))
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
      case .friendPage(let input):
        let output = try await FriendPage.resolve(with: input, in: authed)
        return try respond(with: output)
      case .friendsPage(let lang):
        let output = try await FriendsPage.resolve(with: lang, in: authed)
        return try respond(with: output)
      case .publishedFriendSlugs(let lang):
        let output = try await PublishedFriendSlugs.resolve(with: lang, in: authed)
        return try respond(with: output)
      }
    }
  }
}
