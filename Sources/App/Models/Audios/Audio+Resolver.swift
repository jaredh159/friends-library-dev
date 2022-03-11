import Vapor

// below auto-generated

extension Resolver {
  func getAudio(req: Req, args: IdentifyEntityArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.find(Audio.self, byId: args.id)
    }
  }

  func getAudios(req: Req, args: NoArgs) throws -> Future<[Audio]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.query(Audio.self).all()
    }
  }

  func createAudio(
    req: Req,
    args: InputArgs<AppSchema.CreateAudioInput>
  ) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      let audio = Audio(args.input)
      guard audio.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(audio)
      return try await Current.db.find(created.id)
    }
  }

  func createAudios(
    req: Req,
    args: InputArgs<[AppSchema.CreateAudioInput]>
  ) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Audio].self, on: req.eventLoop) {
      let audios = args.input.map(Audio.init)
      guard audios.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(audios)
      return try await Current.db.query(Audio.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateAudio(
    req: Req,
    args: InputArgs<AppSchema.UpdateAudioInput>
  ) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      let audio = Audio(args.input)
      guard audio.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(audio)
      return try await Current.db.find(audio.id)
    }
  }

  func updateAudios(
    req: Req,
    args: InputArgs<[AppSchema.UpdateAudioInput]>
  ) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Audio].self, on: req.eventLoop) {
      let audios = args.input.map(Audio.init)
      guard audios.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(audios)
      return try await Current.db.query(Audio.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteAudio(req: Req, args: IdentifyEntityArgs) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.delete(Audio.self, byId: args.id)
    }
  }
}
