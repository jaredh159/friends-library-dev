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
  case friendsPage(Lang)

  static let router: AnyParserPrinter<URLRequestData, AuthedNextEvansBuildRoute> = OneOf {
    Route(/Self.friendsPage) {
      Operation(FriendsPage.self)
      Body(.input(FriendsPage.self))
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
      case .friendsPage(let lang):
        let output = try await FriendsPage.resolve(with: lang, in: authed)
        return try respond(with: output)
      }
    }
  }
}
