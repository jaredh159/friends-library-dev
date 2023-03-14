// auto-generated, do not edit
import DuetMock
import GraphQL
import NonEmpty

@testable import App

extension AudioPart {
  static var mock: AudioPart {
    AudioPart(
      audioId: .init(),
      title: "@mock title",
      duration: 42,
      chapters: NonEmpty<[Int]>(42),
      order: 42,
      mp3SizeHq: .init(rawValue: 42),
      mp3SizeLq: .init(rawValue: 42),
      externalIdHq: .init(rawValue: 42),
      externalIdLq: .init(rawValue: 42)
    )
  }

  static var empty: AudioPart {
    AudioPart(
      audioId: .init(),
      title: "",
      duration: 0,
      chapters: NonEmpty<[Int]>(0),
      order: 0,
      mp3SizeHq: .init(rawValue: 0),
      mp3SizeLq: .init(rawValue: 0),
      externalIdHq: .init(rawValue: 0),
      externalIdLq: .init(rawValue: 0)
    )
  }

  static var random: AudioPart {
    AudioPart(
      audioId: .init(),
      title: "@random".random,
      duration: .init(rawValue: Double.random(in: 100...999)),
      chapters: NonEmpty<[Int]>(Int.random),
      order: Int.random,
      mp3SizeHq: .init(rawValue: Int.random),
      mp3SizeLq: .init(rawValue: Int.random),
      externalIdHq: .init(rawValue: Int64.random),
      externalIdLq: .init(rawValue: Int64.random)
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "audioId": .string(audioId.lowercased),
      "title": .string(title),
      "duration": .number(Number(duration.rawValue)),
      "chapters": .array(chapters.array.map { .number(Number($0)) }),
      "order": .number(Number(order)),
      "mp3SizeHq": .number(Number(mp3SizeHq.rawValue)),
      "mp3SizeLq": .number(Number(mp3SizeLq.rawValue)),
      "externalIdHq": .number(Number(externalIdHq.rawValue)),
      "externalIdLq": .number(Number(externalIdLq.rawValue)),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
