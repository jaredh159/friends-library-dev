const RESOLVER_PATTERN = /* swift */ `
// below auto-generated

extension Resolver {
  func getThing(req: Req, args: IdentifyEntityArgs) throws -> Future<Thing> {
    try req.requirePermission(to: .queryThings)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.find(Thing.self, byId: args.id)
    }
  }

  func getThings(req: Req, args: NoArgs) throws -> Future<[Thing]> {
    try req.requirePermission(to: .queryThings)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.query(Thing.self).all()
    }
  }

  func createThing(
    req: Req,
    args: InputArgs<AppSchema.CreateThingInput>
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateThings)
    return future(of: Thing.self, on: req.eventLoop) {
      let thing = Thing(args.input)
      guard thing.isValid else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(thing)
      return try await Current.db.find(created.id)
    }
  }

  func createThings(
    req: Req,
    args: InputArgs<[AppSchema.CreateThingInput]>
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .mutateThings)
    return future(of: [Thing].self, on: req.eventLoop) {
      let things = args.input.map(Thing.init)
      guard things.allSatisfy(\\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(things)
      return try await Current.db.query(Thing.self)
        .where(.id |=| created.map(\\.id))
        .all()
    }
  }

  func updateThing(
    req: Req,
    args: InputArgs<AppSchema.UpdateThingInput>
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateThings)
    return future(of: Thing.self, on: req.eventLoop) {
      let thing = Thing(args.input)
      guard thing.isValid else { throw ModelError.invalidEntity }
      try await Current.db.update(thing)
      return try await Current.db.find(thing.id)
    }
  }

  func updateThings(
    req: Req,
    args: InputArgs<[AppSchema.UpdateThingInput]>
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .mutateThings)
    return future(of: [Thing].self, on: req.eventLoop) {
      let things = args.input.map(Thing.init)
      guard things.allSatisfy(\\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.update(things)
      return try await Current.db.query(Thing.self)
        .where(.id |=| created.map(\\.id))
        .all()
    }
  }

  func deleteThing(req: Req, args: IdentifyEntityArgs) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateThings)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.delete(Thing.self, byId: args.id)
    }
  }
}
`.trim();
