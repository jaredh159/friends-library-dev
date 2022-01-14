import Vapor

// below auto-generated

extension Resolver {
  func getAudio(req: Req, args: IdentifyEntityArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.find(Audio.self, byId: args.id)
    }
  }

  func getAudios(req: Req, args: NoArgs) throws -> Future<[Audio]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.query(Audio.self).all()
    }
  }

  func createAudio(
    req: Req,
    args: AppSchema.CreateAudioArgs
  ) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.create(Audio(args.input))
    }
  }

  func createAudios(
    req: Req,
    args: AppSchema.CreateAudiosArgs
  ) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Audio.init))
    }
  }

  func updateAudio(
    req: Req,
    args: AppSchema.UpdateAudioArgs
  ) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.update(Audio(args.input))
    }
  }

  func updateAudios(
    req: Req,
    args: AppSchema.UpdateAudiosArgs
  ) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Audio.init))
    }
  }

  func deleteAudio(req: Req, args: IdentifyEntityArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.delete(Audio.self, byId: args.id)
    }
  }
}
