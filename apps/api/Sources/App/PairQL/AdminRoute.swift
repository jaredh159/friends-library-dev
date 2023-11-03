import DuetSQL
import Foundation
import PairQL
import Vapor

enum AdminRoute: PairRoute {
  case authed(UUID, AuthedAdminRoute)

  static let router = OneOf {
    Route(/Self.authed) {
      Headers {
        Field("Authorization") {
          Skip { "Bearer " }
          UUID.parser()
        }
      }
      AuthedAdminRoute.router
    }
  }
}

enum AuthedAdminRoute: PairRoute {
  case listFriends

  static let router: AnyParserPrinter<URLRequestData, AuthedAdminRoute> = OneOf {
    Route(/Self.listFriends) {
      Operation(ListFriends.self)
    }
  }
  .eraseToAnyParserPrinter()
}

extension AdminRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .authed(let token, let authedRoute):
      let token = try await Token.query().where(.value == token).first()
      let authed = AuthedContext(requestId: context.requestId, scopes: try await token.scopes())
      switch authedRoute {
      case .listFriends:
        let output = try await ListFriends.resolve(in: authed)
        return try respond(with: output)
      }
    }
  }
}
