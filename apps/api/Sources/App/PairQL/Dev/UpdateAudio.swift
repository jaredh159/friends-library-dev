import PairQL

struct UpdateAudio: Pair {
  static var auth: Scope = .mutateEntities

  struct Input: PairInput {
    let id: Audio.Id
    let editionId: Edition.Id
    let reader: String
    let isIncomplete: Bool
    let mp3ZipSizeHq: Bytes
    let mp3ZipSizeLq: Bytes
    let m4bSizeHq: Bytes
    let m4bSizeLq: Bytes
    let externalPlaylistIdHq: Audio.ExternalPlaylistId?
    let externalPlaylistIdLq: Audio.ExternalPlaylistId?
  }
}

extension UpdateAudio: Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let audio = try await Audio.find(input.id)
    audio.editionId = input.editionId
    audio.reader = input.reader
    audio.isIncomplete = input.isIncomplete
    audio.mp3ZipSizeHq = input.mp3ZipSizeHq
    audio.mp3ZipSizeLq = input.mp3ZipSizeLq
    audio.m4bSizeHq = input.m4bSizeHq
    audio.m4bSizeLq = input.m4bSizeLq
    audio.externalPlaylistIdHq = input.externalPlaylistIdHq
    audio.externalPlaylistIdLq = input.externalPlaylistIdLq
    guard audio.isValid else { throw ModelError.invalidEntity }
    try await audio.save()
    return .success
  }
}
