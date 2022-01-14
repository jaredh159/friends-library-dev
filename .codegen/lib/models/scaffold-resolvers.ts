import Model from './Model';

export function generateResolverScaffold(model: Model): [filepath: string, code: string] {
  const code = RESOLVER_PATTERN.replace(/Thing/g, model.name);
  return [`${model.dir}/${model.name}+Resolver.swift`, code];
}

const RESOLVER_PATTERN = /* swift */ `
// below auto-generated

extension Resolver {
  func getThing(req: Req, args: IdentifyEntityArgs) throws -> Future<Thing> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.find(Thing.self, byId: args.id)
    }
  }

  func getThings(req: Req, args: NoArgs) throws -> Future<[Thing]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.query(Thing.self).all()
    }
  }

  func createThing(
    req: Req,
    args: AppSchema.CreateThingArgs
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.create(Thing(args.input))
    }
  }

  func createThings(
    req: Req,
    args: AppSchema.CreateThingsArgs
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Thing.init))
    }
  }

  func updateThing(
    req: Req,
    args: AppSchema.UpdateThingArgs
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.update(Thing(args.input))
    }
  }

  func updateThings(
    req: Req,
    args: AppSchema.UpdateThingsArgs
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Thing.init))
    }
  }

  func deleteThing(req: Req, args: IdentifyEntityArgs) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.delete(Thing.self, byId: args.id)
    }
  }
}
`.trim();
