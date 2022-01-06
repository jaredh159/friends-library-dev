import Vapor

// below auto-generated

extension Resolver {
  func getAudioPart(req: Req, args: IdentifyEntityArgs) throws -> Future<AudioPart> {
    try req.requirePermission(to: .queryAudios)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.getAudioPart(.init(rawValue: args.id))
    }
  }

  func getAudioParts(req: Req, args: NoArgs) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .queryAudios)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.getAudioParts(nil)
    }
  }

  func createAudioPart(
    req: Req,
    args: AppSchema.CreateAudioPartArgs
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.createAudioPart(AudioPart(args.input))
    }
  }

  func createAudioParts(
    req: Req,
    args: AppSchema.CreateAudioPartsArgs
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.createAudioParts(args.input.map(AudioPart.init))
    }
  }

  func updateAudioPart(
    req: Req,
    args: AppSchema.UpdateAudioPartArgs
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.updateAudioPart(AudioPart(args.input))
    }
  }

  func updateAudioParts(
    req: Req,
    args: AppSchema.UpdateAudioPartsArgs
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.updateAudioParts(args.input.map(AudioPart.init))
    }
  }

  func deleteAudioPart(req: Req, args: IdentifyEntityArgs) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.deleteAudioPart(.init(rawValue: args.id))
    }
  }
}
