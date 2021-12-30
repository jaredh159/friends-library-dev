import { modelDir } from './helpers';

export function generateResolverScaffold(
  modelName: string,
): [filepath: string, code: string] {
  const code = RESOLVER_PATTERN.replace(/Thing/g, modelName);
  return [`Sources/App/Models/${modelDir(modelName)}${modelName}+Resolver.swift`, code];
}

const RESOLVER_PATTERN = /* swift */ `
// below auto-generated

extension Resolver {
  func getThing(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented)
  }

  func getThings(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Thing]> {
    throw Abort(.notImplemented)
  }

  func createThing(
    req: Req,
    args: AppSchema.CreateThingArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented)
  }

  func createThings(
    req: Req,
    args: AppSchema.CreateThingsArgs
  ) throws -> Future<[Thing]> {
    throw Abort(.notImplemented)
  }

  func updateThing(
    req: Req,
    args: AppSchema.UpdateThingArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented)
  }

  func updateThings(
    req: Req,
    args: AppSchema.UpdateThingsArgs
  ) throws -> Future<[Thing]> {
    throw Abort(.notImplemented)
  }

  func deleteThing(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Thing> {
    throw Abort(.notImplemented)
  }
}
`.trim();
