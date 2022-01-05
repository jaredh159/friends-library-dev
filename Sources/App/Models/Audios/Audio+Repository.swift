import Vapor  // temp

extension Repository where Model == Audio {
  func getParts(_ id: Audio.Id) async throws -> [AudioPart] {
    try await findChildren(id, fk: AudioPart[.audioId])
  }

  func assign(client: inout DatabaseClient) {
    client.getAudioAudioParts = { try await getParts($0) }
  }
}

extension MockRepository where Model == Audio {
  func getParts(_ id: Audio.Id) async throws -> [AudioPart] {
    db.find(where: { $0.audioId == id }, in: \.audioParts)
  }

  func assign(client: inout DatabaseClient) {
    client.getAudioAudioParts = { try await getParts($0) }
  }
}
