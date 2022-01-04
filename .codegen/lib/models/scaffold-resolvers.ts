import Model from './Model';

export function generateResolverScaffold(model: Model): [filepath: string, code: string] {
  const code = RESOLVER_PATTERN.replace(/Thing/g, model.name);
  return [`${model.dir}/${model.name}+Resolver.swift`, code];
}

const RESOLVER_PATTERN = /* swift */ `
// below auto-generated

extension Resolver {
  func getThing(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .queryThings)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.getThing(.init(rawValue: args.id))
    }
  }

  func getThings(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .queryThings)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.getThings()
    }
  }

  func createThing(
    req: Req,
    args: AppSchema.CreateThingArgs
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateThings)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.createThing(Thing(args.input))
    }
  }

  func createThings(
    req: Req,
    args: AppSchema.CreateThingsArgs
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .mutateThings)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.createThings(args.input.map(Thing.init))
    }
  }

  func updateThing(
    req: Req,
    args: AppSchema.UpdateThingArgs
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateThings)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.updateThing(Thing(args.input))
    }
  }

  func updateThings(
    req: Req,
    args: AppSchema.UpdateThingsArgs
  ) throws -> Future<[Thing]> {
    try req.requirePermission(to: .mutateThings)
    return future(of: [Thing].self, on: req.eventLoop) {
      try await Current.db.updateThings(args.input.map(Thing.init))
    }
  }

  func deleteThing(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Thing> {
    try req.requirePermission(to: .mutateThings)
    return future(of: Thing.self, on: req.eventLoop) {
      try await Current.db.deleteThing(.init(rawValue: args.id))
    }
  }
}
`.trim();
