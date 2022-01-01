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
    throw Abort(.notImplemented, reason: "Resolver.getThing")
  }

  func getThings(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Thing]> {
    throw Abort(.notImplemented, reason: "Resolver.getThings")
  }

  func createThing(
    req: Req,
    args: AppSchema.CreateThingArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented, reason: "Resolver.createThing")
  }

  func createThings(
    req: Req,
    args: AppSchema.CreateThingsArgs
  ) throws -> Future<[Thing]> {
    throw Abort(.notImplemented, reason: "Resolver.createThings")
  }

  func updateThing(
    req: Req,
    args: AppSchema.UpdateThingArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented, reason: "Resolver.updateThing")
  }

  func updateThings(
    req: Req,
    args: AppSchema.UpdateThingsArgs
  ) throws -> Future<[Thing]> {
    throw Abort(.notImplemented, reason: "Resolver.updateThings")
  }

  func deleteThing(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented, reason: "Resolver.deleteThing")
  }
}
`.trim();
