import NonEmpty
import PairQL

struct UpdateAudioPart: Pair {
  static var auth: Scope = .mutateEntities

  struct Input: PairInput {
    let id: AudioPart.Id
    let audioId: Audio.Id
    let title: String
    let duration: Double
    let chapters: [Int]
    let order: Int
    let mp3SizeHq: Int
    let mp3SizeLq: Int
    let externalIdHq: Int64
    let externalIdLq: Int64
  }

  typealias Output = Infallible
}

extension UpdateAudioPart: PairQL.Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    let audioPart = try await AudioPart.find(input.id)
    audioPart.audioId = input.audioId
    audioPart.title = input.title
    audioPart.duration = .init(input.duration)
    audioPart.chapters = try .fromArray(input.chapters)
    audioPart.order = input.order
    audioPart.mp3SizeHq = .init(input.mp3SizeHq)
    audioPart.mp3SizeLq = .init(input.mp3SizeLq)
    audioPart.externalIdHq = .init(input.externalIdHq)
    audioPart.externalIdLq = .init(input.externalIdLq)
    guard audioPart.isValid else { throw ModelError.invalidEntity }
    try await audioPart.save()
    return .success
  }
}
