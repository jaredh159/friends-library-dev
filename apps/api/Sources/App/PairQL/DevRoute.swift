import DuetSQL
import Foundation
import PairQL
import Vapor

enum DevRoute: PairRoute {
  case authed(UUID, AuthedDevRoute)

  static let router = OneOf {
    Route(/Self.authed) {
      Headers {
        Field("Authorization") {
          Skip { "Bearer " }
          UUID.parser()
        }
      }
      AuthedDevRoute.router
    }
  }
}

enum AuthedDevRoute: PairRoute {
  case createArtifactProductionVersion(CreateArtifactProductionVersion.Input)

  static let router: AnyParserPrinter<URLRequestData, AuthedDevRoute> = OneOf {
    Route(/Self.createArtifactProductionVersion) {
      Operation(CreateArtifactProductionVersion.self)
      Body(.input(CreateArtifactProductionVersion.self))
    }
  }
  .eraseToAnyParserPrinter()
}

extension DevRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .authed(let token, let authedRoute):
      let token = try await Token.query().where(.value == token).first()
      let authed = AuthedContext(requestId: context.requestId, scopes: try await token.scopes())
      switch authedRoute {
      case .createArtifactProductionVersion(let input):
        let output = try await CreateArtifactProductionVersion.resolve(with: input, in: authed)
        return try respond(with: output)
      }
    }
  }
}
