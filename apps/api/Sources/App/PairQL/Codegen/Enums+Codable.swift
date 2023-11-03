// auto-generated, do not edit
import Foundation
import Tagged

extension DeleteEntities.Input {
  private struct _NamedCase: Codable {
    var `case`: String
    static func extract(from decoder: Decoder) throws -> String {
      let container = try decoder.singleValueContainer()
      return try container.decode(_NamedCase.self).case
    }
  }

  private struct _TypeScriptDecodeError: Error {
    var message: String
  }

  private struct _CaseEditionImpression: Codable {
    var `case` = "editionImpression"
    var id: Tagged<App.EditionImpression, UUID>
  }

  private struct _CaseEditionChapters: Codable {
    var `case` = "editionChapters"
    var id: Tagged<App.Edition, UUID>
  }

  func encode(to encoder: Encoder) throws {
    switch self {
    case .editionImpression(let id):
      try _CaseEditionImpression(id: id).encode(to: encoder)
    case .editionChapters(let id):
      try _CaseEditionChapters(id: id).encode(to: encoder)
    }
  }

  init(from decoder: Decoder) throws {
    let caseName = try _NamedCase.extract(from: decoder)
    let container = try decoder.singleValueContainer()
    switch caseName {
    case "editionImpression":
      let value = try container.decode(_CaseEditionImpression.self)
      self = .editionImpression(id: value.id)
    case "editionChapters":
      let value = try container.decode(_CaseEditionChapters.self)
      self = .editionChapters(id: value.id)
    default:
      throw _TypeScriptDecodeError(message: "Unexpected case name: `\(caseName)`")
    }
  }
}
