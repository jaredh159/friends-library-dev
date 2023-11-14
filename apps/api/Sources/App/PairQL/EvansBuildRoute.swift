import DuetSQL
import Foundation
import PairQL
import Vapor

enum EvansBuildRoute: PairRoute {
  case authed(UUID, AuthedEvansBuildRoute)

  static let router = OneOf {
    Route(/Self.authed) {
      Headers {
        Field("Authorization") {
          Skip { "Bearer " }
          UUID.parser()
        }
      }
      AuthedEvansBuildRoute.router
    }
  }
}

enum AuthedEvansBuildRoute: PairRoute {
  case getFriends
  case getDocumentDownloadCounts

  static let router: AnyParserPrinter<URLRequestData, AuthedEvansBuildRoute> = OneOf {
    Route(/Self.getFriends) {
      Operation(GetFriends.self)
    }
    Route(/Self.getDocumentDownloadCounts) {
      Operation(GetDocumentDownloadCounts.self)
    }
  }
  .eraseToAnyParserPrinter()
}

extension EvansBuildRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .authed(let token, let authedRoute):
      let token = try await Token.query().where(.value == token).first()
      let authed = AuthedContext(requestId: context.requestId, scopes: try await token.scopes())
      switch authedRoute {
      case .getDocumentDownloadCounts:
        let output = try await GetDocumentDownloadCounts.resolve(in: authed)
        return try respond(with: output)
      case .getFriends:
        let output = try await GetFriends.resolve(in: authed)
        return try respond(with: output)
      }
    }
  }
}
