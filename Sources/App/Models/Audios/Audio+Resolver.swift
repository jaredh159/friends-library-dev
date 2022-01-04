import Vapor

extension Resolver {
  // 👋 start here, implementing CRUD for audio
  // then do audio part
  // then do FriendResidence
  // then do FriendQuote
  // then hook up all relations
  func createAudio(
    req: Req,
    args: AppSchema.CreateAudioArgs
  ) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: Audio.self, on: req.eventLoop) {
      let audio = Audio(args.input)
      try await Current.db.createAudio(audio)
      return audio
    }
  }
}

// below auto-generated

extension Resolver {
  func getAudio(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Audio> {
    throw Abort(.notImplemented, reason: "Resolver.getAudio")
  }

  func getAudios(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Audio]> {
    throw Abort(.notImplemented, reason: "Resolver.getAudios")
  }

  func createAudios(
    req: Req,
    args: AppSchema.CreateAudiosArgs
  ) throws -> Future<[Audio]> {
    throw Abort(.notImplemented, reason: "Resolver.createAudios")
  }

  func updateAudio(
    req: Req,
    args: AppSchema.UpdateAudioArgs
  ) throws -> Future<Audio> {
    throw Abort(.notImplemented, reason: "Resolver.updateAudio")
  }

  func updateAudios(
    req: Req,
    args: AppSchema.UpdateAudiosArgs
  ) throws -> Future<[Audio]> {
    throw Abort(.notImplemented, reason: "Resolver.updateAudios")
  }

  func deleteAudio(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Audio> {
    throw Abort(.notImplemented, reason: "Resolver.deleteAudio")
  }
}
