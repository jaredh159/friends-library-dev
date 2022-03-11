import Vapor

// below auto-generated

extension Resolver {
  func getAudioPart(req: Req, args: IdentifyEntityArgs) throws -> Future<AudioPart> {
    try req.requirePermission(to: .queryEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.find(AudioPart.self, byId: args.id)
    }
  }

  func getAudioParts(req: Req, args: NoArgs) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.query(AudioPart.self).all()
    }
  }

  func createAudioPart(
    req: Req,
    args: InputArgs<AppSchema.CreateAudioPartInput>
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      let audiopart = try AudioPart(args.input)
      guard audiopart.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(audiopart)
      return try await Current.db.find(created.id)
    }
  }

  func createAudioParts(
    req: Req,
    args: InputArgs<[AppSchema.CreateAudioPartInput]>
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      let audioparts = try args.input.map(AudioPart.init)
      guard audioparts.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(audioparts)
      return try await Current.db.query(AudioPart.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateAudioPart(
    req: Req,
    args: InputArgs<AppSchema.UpdateAudioPartInput>
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      let audiopart = try AudioPart(args.input)
      guard audiopart.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(audiopart)
      return try await Current.db.find(audiopart.id)
    }
  }

  func updateAudioParts(
    req: Req,
    args: InputArgs<[AppSchema.UpdateAudioPartInput]>
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      let audioparts = try args.input.map(AudioPart.init)
      guard audioparts.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(audioparts)
      return try await Current.db.query(AudioPart.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteAudioPart(req: Req, args: IdentifyEntityArgs) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.delete(AudioPart.self, byId: args.id)
    }
  }
}
