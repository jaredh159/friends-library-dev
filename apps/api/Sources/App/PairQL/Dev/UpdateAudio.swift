import PairQL

struct UpdateAudio: Pair {
  static var auth: Scope = .mutateEntities

  struct Input: PairInput {
    let id: Audio.Id
    let editionId: Edition.Id
    let reader: String
    let isIncomplete: Bool
    let mp3ZipSizeHq: Int
    let mp3ZipSizeLq: Int
    let m4bSizeHq: Int
    let m4bSizeLq: Int
    let externalPlaylistIdHq: Int64?
    let externalPlaylistIdLq: Int64?
  }

  typealias Output = Infallible
}

extension UpdateAudio: PairQL.Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    let audio = try await Audio.find(input.id)
    audio.editionId = input.editionId
    audio.reader = input.reader
    audio.isIncomplete = .init(input.isIncomplete)
    audio.mp3ZipSizeHq = .init(input.mp3ZipSizeHq)
    audio.mp3ZipSizeLq = .init(input.mp3ZipSizeLq)
    audio.m4bSizeHq = .init(input.m4bSizeHq)
    audio.externalPlaylistIdHq = input.externalPlaylistIdHq.map { .init($0) }
    audio.externalPlaylistIdLq = input.externalPlaylistIdLq.map { .init($0) }
    guard audio.isValid else { throw ModelError.invalidEntity }
    try await audio.save()
    return .success
  }
}
