import { GlobalTypes, Model } from '../types';
import { modelDir } from './helpers';

export function generateModelGraphQLTypes(
  model: Model,
  types: GlobalTypes,
): [filepath: string, code: string] {
  let code = GQL_PATTERN;

  code = code.replace(
    `/* GRAPHQL_SCHEMA_TYPE */`,
    schemaTypeFieldPairs(model, types)
      .map(([prop, path]) => `Field("${prop}", at: ${path})`)
      .join(`\n      `),
  );

  code = code.replace(
    /\/\* GRAPHQL_REQUEST_INPUT_CREATE_UPDATE \*\//g,
    requestInputPairs(model, types)
      .map(([name, type]) => `let ${name}: ${type}`)
      .join(`\n    `),
  );

  code = code.replace(
    /\/\* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE \*\//g,
    model.props
      .map((prop) => prop.name)
      .filter((name) => !isTimestamp(name))
      .map((name) => `InputField("${name}", at: \\.${name})`)
      .join(`\n      `),
  );

  code = code.replace(
    `/* CONVENIENCE_INIT */`,
    model.init
      .map((prop) => prop.propName)
      .filter((name) => !isTimestamp(name))
      .map((name) => `${name}: ${modelPropToInitArg(name, model, types)}`)
      .join(`,\n      `),
  );

  const updateSetters = model.props
    .map((prop) => prop.name)
    .filter((name) => !isTimestamp(name))
    .filter((name) => name != `id`)
    .map((name) => `self.${name} = ${modelPropToInitArg(name, model, types)}`);

  if (model.props.find((p) => p.name === `updatedAt`)) {
    updateSetters.push(`self.updatedAt = Current.date()`);
  }

  code = code.replace(`/* FUNC_UPDATE */`, updateSetters.join(`\n    `));
  code = code.replace(/Thing/g, model.name);

  if (!code.match(/ try\?? /)) {
    code.replace(/ throws /g, ` `);
  }

  if (!code.match(/ NonEmpty< /)) {
    code.replace(`import NonEmpty\n`, ``);
  }

  return [`Sources/App/Models/Generated/${model.name}+GraphQL.swift`, code + `\n`];
}

function isTimestamp(name: string): boolean {
  return [`createdAt`, `updatedAt`, `deletedAt`].includes(name);
}

export function schemaTypeFieldPairs(
  model: Model,
  types: GlobalTypes,
): Array<[string, string]> {
  return model.props
    .filter((p) => p.name !== `deletedAt`)
    .map(({ name, type }) => [name, keyPath(name, type, model, types)]);
}

function requestInputPairs(model: Model, types: GlobalTypes): Array<[string, string]> {
  return model.props
    .filter((p) => ![`id`, `createdAt`, `updatedAt`, `deletedAt`].includes(p.name))
    .map(({ name, type }) => [name, modelTypeToGraphQLInputType(type, model, types)]);
}

export function modelTypeToGraphQLInputType(
  type: string,
  model: Model,
  types: GlobalTypes,
): string {
  const isOptional = type.endsWith(`?`);
  const opt = isOptional ? `?` : ``;
  type = type.replace(/\?$/, ``);
  if (type === `Id` || type.endsWith(`.Id`)) {
    return `UUID${opt}`;
  }
  const tagged = model.taggedTypes[type] || types.taggedTypes[type];
  if (tagged) {
    return `${tagged}${opt}`;
  }

  switch (type) {
    case `Seconds<Double>`:
      return `Double${opt}`;
    case `Cents<Int>`:
    case `Seconds<Int>`:
      return `Int${opt}`;
    case `NonEmpty<[Int]>`:
      return `[Int]${opt}`;
  }

  if (model.dbEnums[type] || (model.name === `FriendResidence` && type === `Duration`)) {
    return `${model.name}.${type}${opt}`;
  }

  return `${type}${opt}`;
}

export function modelPropToInitArg(
  name: string,
  model: Model,
  types: GlobalTypes,
): string {
  const prop = model.props.find((p) => p.name === name);
  if (!prop) {
    throw new Error(`Can't resolve type for ${model.name}.${name}`);
  }
  const isOptional = prop.type.endsWith(`?`);
  const type = prop.type.replace(/\?$/, ``);
  if (name == `id`) {
    return `.init(rawValue: input.id ?? UUID())`;
  }

  const isTagged =
    model.taggedTypes[type] !== undefined ||
    types.taggedTypes[type] !== undefined ||
    [`Seconds<Double>`, `Cents<Int>`, `Seconds<Int>`].includes(type) ||
    type.endsWith(`.Id`);

  if (isTagged && isOptional) {
    return `input.${name} != nil ? .init(rawValue: input.${name}!) : nil`;
  } else if (isTagged) {
    return `.init(rawValue: input.${name})`;
  }

  if (type === `NonEmpty<[Int]>`) {
    let nonEmpty = `NonEmpty<[Int]>.fromArray(input.${name}`;
    if (isOptional) {
      return `try? ${nonEmpty} ?? [])`;
    } else {
      return `try ${nonEmpty})`;
    }
  }

  return `input.${name}`;
}

function keyPath(
  name: string,
  type: string,
  model: Model,
  globalTypes: GlobalTypes,
): string {
  let keyPath = `\\.${name}`;
  const isOptional = type.endsWith(`?`);
  type = type.replace(/\?$/, ``);
  if (
    type === `Id` ||
    model.taggedTypes[type] ||
    globalTypes.taggedTypes[type] ||
    [`Cents<Int>`, `NonEmpty<[Int]>`].includes(type) ||
    type.endsWith(`.Id`)
  ) {
    keyPath += `${isOptional ? `?` : ``}.rawValue`;
  }
  return keyPath;
}

const GQL_PATTERN = /* swift */ `
// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Thing {
  enum GraphQL {
    enum Schema {
      enum Inputs {}
      enum Queries {}
      enum Mutations {}
    }
    enum Request {
      enum Inputs {}
      enum Args {}
    }
  }
}

extension Thing.GraphQL.Schema {
  static var type: AppType<Thing> {
    Type(Thing.self) {
      /* GRAPHQL_SCHEMA_TYPE */
    }
  }
}

extension Thing.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    /* GRAPHQL_REQUEST_INPUT_CREATE_UPDATE */
  }

  struct Update: Codable {
    let id: UUID
    /* GRAPHQL_REQUEST_INPUT_CREATE_UPDATE */
  }
}

extension Thing.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Thing.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Thing.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Thing.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Thing.GraphQL.Request.Inputs.Create]
  }
}

extension Thing.GraphQL.Schema.Inputs {
  static var create: AppInput<Thing.GraphQL.Request.Inputs.Create> {
    Input(Thing.GraphQL.Request.Inputs.Create.self) {
      /* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE */
    }
  }

  static var update: AppInput<Thing.GraphQL.Request.Inputs.Update> {
    Input(Thing.GraphQL.Request.Inputs.Update.self) {
      /* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE */
    }
  }
}

extension Thing.GraphQL.Schema.Queries {
  static var get: AppField<Thing, IdentifyEntityArgs> {
    Field("getThing", at: Resolver.getThing) {
      Argument("id", at: \\.id)
    }
  }

  static var list: AppField<[Thing], NoArgs> {
    Field("getThings", at: Resolver.getThings)
  }
}

extension Thing.GraphQL.Schema.Mutations {
  static var create: AppField<Thing, Thing.GraphQL.Request.Args.Create> {
    Field("createThing", at: Resolver.createThing) {
      Argument("input", at: \\.input)
    }
  }

  static var createMany: AppField<[Thing], Thing.GraphQL.Request.Args.CreateMany> {
    Field("createThing", at: Resolver.createThings) {
      Argument("input", at: \\.input)
    }
  }

  static var update: AppField<Thing, Thing.GraphQL.Request.Args.Update> {
    Field("createThing", at: Resolver.updateThing) {
      Argument("input", at: \\.input)
    }
  }

  static var updateMany: AppField<[Thing], Thing.GraphQL.Request.Args.UpdateMany> {
    Field("createThing", at: Resolver.updateThings) {
      Argument("input", at: \\.input)
    }
  }

  static var delete: AppField<Thing, IdentifyEntityArgs> {
    Field("deleteThing", at: Resolver.deleteThing) {
      Argument("id", at: \\.id)
    }
  }
}

extension Thing {
  convenience init(_ input: Thing.GraphQL.Request.Inputs.Create) throws {
    self.init(
      /* CONVENIENCE_INIT */
    )
  }

  func update(_ input: Thing.GraphQL.Request.Inputs.Update) throws {
    /* FUNC_UPDATE */
  }
}
`.trim();
