import Vapor

extension Resolver {
  func createAudio(req: Req, args: AppSchema.CreateAudioArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.createAudio(Audio(args.input))
    }
  }

  func getAudio(req: Req, args: IdentifyEntityArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .queryAudios)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.getAudio(.init(rawValue: args.id))
    }
  }

  func updateAudio(req: Req, args: AppSchema.UpdateAudioArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.updateAudio(Audio(args.input))
    }
  }

  func deleteAudio(req: Req, args: IdentifyEntityArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.deleteAudio(.init(rawValue: args.id))
    }
  }

  func getAudios(req: Req, args: NoArgs) throws -> Future<[Audio]> {
    try req.requirePermission(to: .queryAudios)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.getAudios()
    }
  }

  func createAudios(req: Req, args: AppSchema.CreateAudiosArgs) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.createAudios(args.input.map(Audio.init))
    }
  }

  func updateAudios(req: Req, args: AppSchema.UpdateAudiosArgs) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateAudios)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.updateAudios(args.input.map(Audio.init))
    }
  }
}
