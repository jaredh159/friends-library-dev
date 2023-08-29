import GraphQL

@testable import App

extension Audio {
  static var mock: Audio {
    Audio(
      editionId: .init(),
      reader: "@mock reader",
      mp3ZipSizeHq: .init(rawValue: 42),
      mp3ZipSizeLq: .init(rawValue: 42),
      m4bSizeHq: .init(rawValue: 42),
      m4bSizeLq: .init(rawValue: 42)
    )
  }

  static var empty: Audio {
    Audio(
      editionId: .init(),
      reader: "",
      mp3ZipSizeHq: .init(rawValue: 0),
      mp3ZipSizeLq: .init(rawValue: 0),
      m4bSizeHq: .init(rawValue: 0),
      m4bSizeLq: .init(rawValue: 0)
    )
  }

  static var random: Audio {
    Audio(
      editionId: .init(),
      reader: "@random".random,
      mp3ZipSizeHq: .init(rawValue: Int.random),
      mp3ZipSizeLq: .init(rawValue: Int.random),
      m4bSizeHq: .init(rawValue: Int.random),
      m4bSizeLq: .init(rawValue: Int.random)
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "editionId": .string(editionId.lowercased),
      "reader": .string(reader),
      "isIncomplete": .bool(isIncomplete),
      "mp3ZipSizeHq": .number(Number(mp3ZipSizeHq.rawValue)),
      "mp3ZipSizeLq": .number(Number(mp3ZipSizeLq.rawValue)),
      "m4bSizeHq": .number(Number(m4bSizeHq.rawValue)),
      "m4bSizeLq": .number(Number(m4bSizeLq.rawValue)),
      "externalPlaylistIdHq": externalPlaylistIdHq != nil ?
        .number(Number(externalPlaylistIdHq!.rawValue)) : .null,
      "externalPlaylistIdLq": externalPlaylistIdLq != nil ?
        .number(Number(externalPlaylistIdLq!.rawValue)) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
