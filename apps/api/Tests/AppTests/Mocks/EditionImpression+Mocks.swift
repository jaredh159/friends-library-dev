// auto-generated, do not edit
import DuetMock
import GraphQL
import NonEmpty

@testable import App

extension EditionImpression {
  static var mock: EditionImpression {
    EditionImpression(
      editionId: .init(),
      adocLength: 42,
      paperbackSizeVariant: .s,
      paperbackVolumes: NonEmpty<[Int]>(42),
      publishedRevision: "@mock publishedRevision",
      productionToolchainRevision: "@mock productionToolchainRevision"
    )
  }

  static var empty: EditionImpression {
    EditionImpression(
      editionId: .init(),
      adocLength: 0,
      paperbackSizeVariant: .s,
      paperbackVolumes: NonEmpty<[Int]>(0),
      publishedRevision: "",
      productionToolchainRevision: ""
    )
  }

  static var random: EditionImpression {
    EditionImpression(
      editionId: .init(),
      adocLength: Int.random,
      paperbackSizeVariant: PrintSizeVariant.allCases.shuffled().first!,
      paperbackVolumes: NonEmpty<[Int]>(Int.random),
      publishedRevision: .init(rawValue: "@random".random),
      productionToolchainRevision: .init(rawValue: "@random".random)
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "editionId": .string(editionId.lowercased),
      "adocLength": .number(Number(adocLength)),
      "paperbackSizeVariant": .string(paperbackSizeVariant.rawValue),
      "paperbackVolumes": .array(paperbackVolumes.array.map { .number(Number($0)) }),
      "publishedRevision": .string(publishedRevision.rawValue),
      "productionToolchainRevision": .string(productionToolchainRevision.rawValue),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
