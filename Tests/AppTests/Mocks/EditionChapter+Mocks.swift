// auto-generated, do not edit
import GraphQL

@testable import App

extension EditionChapter {
  static var mock: EditionChapter {
    EditionChapter(
      editionId: .init(),
      order: 42,
      shortHeading: "@mock shortHeading",
      isIntermediateTitle: true
    )
  }

  static var empty: EditionChapter {
    EditionChapter(editionId: .init(), order: 0, shortHeading: "", isIntermediateTitle: false)
  }

  static var random: EditionChapter {
    EditionChapter(
      editionId: .init(),
      order: Int.random,
      shortHeading: "@random".random,
      isIntermediateTitle: Bool.random()
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "editionId": .string(editionId.rawValue.uuidString),
      "order": .number(Number(order)),
      "shortHeading": .string(shortHeading),
      "isIntermediateTitle": .bool(isIntermediateTitle),
      "customId": customId != nil ? .string(customId!) : .null,
      "sequenceNumber": sequenceNumber != nil ? .number(Number(sequenceNumber!)) : .null,
      "nonSequenceTitle": nonSequenceTitle != nil ? .string(nonSequenceTitle!) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
