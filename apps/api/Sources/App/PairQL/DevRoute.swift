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
  case editorDocumentMap
  case getAudios
  case latestArtifactProductionVersion
  case updateAudio(UpdateAudio.Input)
  case updateAudioPart(UpdateAudioPart.Input)

  static let router: AnyParserPrinter<URLRequestData, AuthedDevRoute> = OneOf {
    Route(/Self.createArtifactProductionVersion) {
      Operation(CreateArtifactProductionVersion.self)
      Body(.input(CreateArtifactProductionVersion.self))
    }
    Route(/Self.editorDocumentMap) {
      Operation(EditorDocumentMap.self)
    }
    Route(/Self.getAudios) {
      Operation(GetAudios.self)
    }
    Route(/Self.latestArtifactProductionVersion) {
      Operation(LatestArtifactProductionVersion.self)
    }
    Route(/Self.updateAudio) {
      Operation(UpdateAudio.self)
      Body(.input(UpdateAudio.self))
    }
    Route(/Self.updateAudioPart) {
      Operation(UpdateAudioPart.self)
      Body(.input(UpdateAudioPart.self))
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
      case .getAudios:
        let output = try await GetAudios.resolve(in: authed)
        return try respond(with: output)
      case .latestArtifactProductionVersion:
        let output = try await LatestArtifactProductionVersion.resolve(in: authed)
        return try respond(with: output)
      case .editorDocumentMap:
        let output = try await EditorDocumentMap.resolve(in: authed)
        return try respond(with: output)
      case .updateAudio(let input):
        let output = try await UpdateAudio.resolve(with: input, in: authed)
        return try respond(with: output)
      case .updateAudioPart(let input):
        let output = try await UpdateAudioPart.resolve(with: input, in: authed)
        return try respond(with: output)
      }
    }
  }
}
