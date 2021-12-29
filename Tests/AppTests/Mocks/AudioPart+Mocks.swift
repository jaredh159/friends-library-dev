// auto-generated, do not edit
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
}
