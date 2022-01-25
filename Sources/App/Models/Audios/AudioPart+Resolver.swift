import Vapor

// below auto-generated

extension Resolver {
  func getAudioPart(req: Req, args: IdentifyEntityArgs) throws -> Future<AudioPart> {
    try req.requirePermission(to: .queryFriends)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.find(AudioPart.self, byId: args.id)
    }
  }

  func getAudioParts(req: Req, args: NoArgs) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.query(AudioPart.self).all()
    }
  }

  func createAudioPart(
    req: Req,
    args: InputArgs<AppSchema.CreateAudioPartInput>
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.create(AudioPart(args.input))
    }
  }

  func createAudioParts(
    req: Req,
    args: InputArgs<[AppSchema.CreateAudioPartInput]>
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(AudioPart.init))
    }
  }

  func updateAudioPart(
    req: Req,
    args: InputArgs<AppSchema.UpdateAudioPartInput>
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.update(AudioPart(args.input))
    }
  }

  func updateAudioParts(
    req: Req,
    args: InputArgs<[AppSchema.UpdateAudioPartInput]>
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(AudioPart.init))
    }
  }

  func deleteAudioPart(req: Req, args: IdentifyEntityArgs) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.delete(AudioPart.self, byId: args.id)
    }
  }
}
