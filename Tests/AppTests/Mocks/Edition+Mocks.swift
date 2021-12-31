// auto-generated, do not edit
import GraphQL

@testable import App

extension Edition {
  static var mock: Edition {
    Edition(documentId: .init(), type: .updated, editor: nil)
  }

  static var empty: Edition {
    Edition(documentId: .init(), type: .updated, editor: nil)
  }

  static var random: Edition {
    Edition(
      documentId: .init(),
      type: EditionType.allCases.shuffled().first!,
      editor: Bool.random() ? "@random".random : nil
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "documentId": .string(documentId.rawValue.uuidString),
      "type": .string(type.rawValue),
      "editor": editor != nil ? .string(editor!) : .null,
      "isDraft": .bool(isDraft),
      "paperbackSplits": paperbackSplits != nil ? .array(paperbackSplits!.array.map { .number(Number($0)) }) : .null,
      "paperbackOverrideSize": paperbackOverrideSize != nil ? .string(paperbackOverrideSize!.rawValue) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
