import { pluralize } from '../script-helpers';
import { GlobalTypes } from '../types';
import Model from './Model';

export function generateModelGraphQLTypes(
  model: Model,
  types: GlobalTypes,
): [filepath: string, code: string] {
  let code = GQL_PATTERN;

  code = code.replace(
    `/* GRAPHQL_SCHEMA_TYPE */`,
    schemaTypeFieldParts(model, types)
      .map(([prop, label, path]) => `Field("${prop}", ${label}: ${path})`)
      .join(`\n      `),
  );

  code = code.replace(
    /\/\* GRAPHQL_REQUEST_INPUT_CREATE \*\//g,
    requestInputPairs(model, types, `create`)
      .map(([name, type]) => `let ${name}: ${type}`)
      .join(`\n    `),
  );

  code = code.replace(
    /\/\* GRAPHQL_REQUEST_INPUT_UPDATE \*\//g,
    requestInputPairs(model, types, `update`)
      .map(([name, type]) => `let ${name}: ${type}`)
      .join(`\n    `),
  );

  code = code.replace(
    /\/\* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE \*\//g,
    model.props
      .filter((prop) => !isSideLoaded(prop, model, types.sideLoaded))
      .map((prop) => prop.name)
      .filter((name) => !isRequiredTimestamp(name, model))
      .map((name) => `InputField("${name}", at: \\.${name})`)
      .join(`\n      `),
  );

  const convenienceInitCreate = formatInit(
    model.init
      .map((prop) => prop.propName)
      .filter((name) => !isRequiredPropWithInitDefault(name, model))
      .filter((name) => !isRequiredTimestamp(name, model))
      .map((name) => `${name}: ${modelPropToInitArg(name, model, types, `create_init`)}`),
  );

  code = code.replace(`/* CONVENIENCE_INIT_CREATE */`, convenienceInitCreate);

  let convenienceInitCreateSetters = ``;
  const initPostProcessVars = model.init
    .map((prop) => prop.propName)
    .filter((name) => isRequiredPropWithInitDefault(name, model));

  if (initPostProcessVars.length > 0) {
    convenienceInitCreateSetters =
      `\n    ` +
      initPostProcessVars
        .map((name) => {
          const setter = modelPropToInitArg(name, model, types, `unwrapped`);
          return `if let ${name} = input.${name} {\n      self.${name} = ${setter}\n    }`;
        })
        .join(`\n    `);
  }

  code = code.replace(
    `/* CONVENIENCE_INIT_CREATE_SETTERS */`,
    convenienceInitCreateSetters,
  );

  const convenienceInitUpdate = formatInit(
    model.init
      .map((prop) => prop.propName)
      .filter((name) => !isRequiredTimestamp(name, model))
      .map((name) => `${name}: ${modelPropToInitArg(name, model, types, `update_init`)}`),
  );

  code = code.replace(`/* CONVENIENCE_INIT_UPDATE */`, convenienceInitUpdate);

  const updateSetters = model.props
    .filter((prop) => !isSideLoaded(prop, model, types.sideLoaded))
    .map((prop) => prop.name)
    .filter((name) => !isRequiredTimestamp(name, model))
    .filter((name) => name != `id`)
    .map((name) => `${name} = ${modelPropToInitArg(name, model, types, `update_func`)}`);

  if (model.props.find((p) => p.name === `updatedAt`)) {
    updateSetters.push(`updatedAt = Current.date()`);
  }

  const funcUpdateSetters = updateSetters.join(`\n    `);
  code = code.replace(`/* FUNC_UPDATE */`, funcUpdateSetters);
  code = code.replace(/Things/g, pluralize(model.name));
  code = code.replace(/Thing/g, model.name);

  code = code.replace(
    ` /* update_func_throws */ `,
    hasTry(funcUpdateSetters) ? ` throws ` : ` `,
  );

  code = code.replace(
    ` /* update_init_throws */ `,
    hasTry(convenienceInitUpdate) ? ` throws ` : ` `,
  );

  code = code.replace(
    ` /* create_throws */ `,
    hasTry(convenienceInitCreate + convenienceInitCreateSetters) ? ` throws ` : ` `,
  );

  if (!code.match(/ NonEmpty</)) {
    code = code.replace(`import NonEmpty\n`, ``);
  }

  return [`Sources/App/Models/Generated/${model.name}+GraphQL.swift`, code + `\n`];
}

export function isTimestamp(name: string): boolean {
  return [`createdAt`, `updatedAt`, `deletedAt`].includes(name);
}

export function isRequiredTimestamp(name: string, model: Model): boolean {
  if (!isTimestamp(name)) {
    return false;
  }
  if (isRequiredDeletedAtWithInitDefault(name, model)) {
    return false;
  }
  if (isNonAutoGeneratedCreatedAtWithNoInitDefault(name, model)) {
    return false;
  }
  const [prop] = getPropMeta(name, model);
  return prop.type === `Date`;
}

function getPropMeta(name: string, model: Model): [Model['props'][0], Model['init'][0]?] {
  const prop = model.props.find((p) => p.name === name);
  const init = model.init.find((p) => p.propName === name);
  if (!prop) {
    throw new Error(`unexpectedly could not find prop meta ${name}`);
  }
  return [prop, init];
}

function isRequiredDeletedAtWithInitDefault(name: string, model: Model): boolean {
  return name === `deletedAt` && isRequiredPropWithInitDefault(name, model);
}

/**
 * Almost all `created_at` columns are auto-generated with CURRENT_TIMESTAMP.
 * This detects rare cases where we want (and require) the `created_at` value
 * to be manually set as part of the initializer
 */
function isNonAutoGeneratedCreatedAtWithNoInitDefault(
  name: string,
  model: Model,
): boolean {
  if (name !== `createdAt`) {
    return false;
  }

  const [prop, init] = getPropMeta(name, model);
  return prop.type === `Date` && init?.hasDefault === false;
}

function isRequiredPropWithInitDefault(name: string, model: Model): boolean {
  const [prop, init] = getPropMeta(name, model);
  if (prop.type.endsWith(`?`) || !init) {
    return false;
  }
  return init.hasDefault;
}

export function schemaTypeFieldParts(
  model: Model,
  types: GlobalTypes,
): Array<[string, string, string]> {
  const parts: Array<[string, string, string]> = model.props
    .filter((p) => p.name !== `deletedAt` && p.name !== `password`)
    .map(({ name, type }) => [
      type === `Cents<Int>` ? `${name}InCents` : name,
      `at`,
      keyPath(name, type, model, types),
    ]);

  for (const { name, type } of model.computedProps) {
    const fieldName = type === `Cents<Int>` ? `${name}InCents` : name;
    parts.push([fieldName, `at`, keyPath(name, type, model, types)]);
  }

  for (const [name] of Object.entries(model.relations)) {
    parts.push([name, `with`, `\\.${name}`]);
  }

  return parts;
}

function requestInputPairs(
  model: Model,
  types: GlobalTypes,
  context: 'create' | 'update',
): Array<[string, string]> {
  return model.props
    .filter((p) => ![`id`, `updatedAt`].includes(p.name))
    .filter((p) => !isSideLoaded(p, model, types.sideLoaded))
    .filter(
      (p) =>
        p.name !== `createdAt` ||
        isNonAutoGeneratedCreatedAtWithNoInitDefault(p.name, model),
    )
    .map(({ name, type }) => {
      const makeOptional =
        context === `create` && isRequiredPropWithInitDefault(name, model);
      return [
        name,
        modelTypeToGraphQLInputType(type, model, types) + (makeOptional ? `?` : ``),
      ];
    });
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

  if (model.jsonables.includes(type) || types.jsonables.includes(type)) {
    return `String${opt}`;
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
    case `Date`:
      return `String${opt}`;
  }

  if (model.dbEnums[type]) {
    return `${model.name}.${type}${opt}`;
  }

  return `${type}${opt}`;
}

export function modelPropToInitArg(
  name: string,
  model: Model,
  types: GlobalTypes,
  context: 'create_init' | 'update_init' | 'update_func' | 'unwrapped',
): string {
  const input = context === `unwrapped` ? `` : `input.`;
  const prop = model.props.find((p) => p.name === name);
  if (!prop) {
    throw new Error(`Can't resolve type for ${model.name}.${name}`);
  }
  const isOptional = prop.type.endsWith(`?`);
  const type = prop.type.replace(/\?$/, ``);
  if (name == `id`) {
    return context === `create_init`
      ? `.init(rawValue: ${input}id ?? UUID())`
      : `.init(rawValue: ${input}id)`;
  }

  const isJsonable = model.jsonables.includes(type) || types.jsonables.includes(type);
  if (isJsonable && isOptional) {
    return `${input}${name}.map { try .init(fromPostgresJson: $0) }`;
  } else if (isJsonable) {
    return `try .init(fromPostgresJson: ${input}${name})`;
  }

  const isTagged =
    model.taggedTypes[type] !== undefined ||
    types.taggedTypes[type] !== undefined ||
    [`Seconds<Double>`, `Cents<Int>`, `Seconds<Int>`].includes(type) ||
    type.endsWith(`.Id`);

  if (isTagged && isOptional) {
    return `${input}${name}.map { .init(rawValue: $0) }`;
  } else if (isTagged) {
    return `.init(rawValue: ${input}${name})`;
  }

  if (type === `NonEmpty<[Int]>`) {
    let nonEmpty = `NonEmpty<[Int]>.fromArray(${input}${name}`;
    if (isOptional) {
      return `try? ${nonEmpty} ?? [])`;
    } else {
      return `try ${nonEmpty})`;
    }
  }

  if (type !== `Date`) {
    return `${input}${name}`;
  }

  if (context !== `unwrapped` && isOptional) {
    return `try ${input}${name}.flatMap { try Date(fromIsoString: $0) }`;
  } else if (context === `unwrapped`) {
    return `(try? Date(fromIsoString: ${input}${name})) ?? self.${name}`;
  } else if (
    (context !== `update_init` && isRequiredDeletedAtWithInitDefault(name, model)) ||
    isNonAutoGeneratedCreatedAtWithNoInitDefault(name, model)
  ) {
    const fallback = name === `createdAt` && context !== `update_func` ? `Date()` : name;
    return `try Date(fromIsoString: ${input}${name}) ?? ${fallback}`;
  } else {
    return `try Date(fromIsoString: ${input}${name})`;
  }
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
    [`Seconds<Int>`, `Seconds<Double>`, `Cents<Int>`, `NonEmpty<[Int]>`].includes(type) ||
    type.endsWith(`.Id`)
  ) {
    keyPath += `${isOptional ? `?` : ``}.rawValue`;
  }
  if (
    type === `Id` ||
    type === `UUID` ||
    model.taggedTypes[type] === `UUID` ||
    globalTypes.taggedTypes[type] === `UUID` ||
    type.endsWith(`.Id`)
  ) {
    keyPath += `.lowercased`;
  }
  return keyPath;
}

const GQL_PATTERN = /* swift */ `
// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var ThingType: ModelType<Thing> {
    Type(Thing.self) {
      /* GRAPHQL_SCHEMA_TYPE */
    }
  }

  struct CreateThingInput: Codable {
    let id: UUID?
    /* GRAPHQL_REQUEST_INPUT_CREATE */
  }

  struct UpdateThingInput: Codable {
    let id: UUID
    /* GRAPHQL_REQUEST_INPUT_UPDATE */
  }

  static var CreateThingInputType: AppInput<CreateThingInput> {
    Input(CreateThingInput.self) {
      /* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE */
    }
  }

  static var UpdateThingInputType: AppInput<UpdateThingInput> {
    Input(UpdateThingInput.self) {
      /* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE */
    }
  }

  static var getThing: AppField<Thing, IdentifyEntityArgs> {
    Field("getThing", at: Resolver.getThing) {
      Argument("id", at: \\.id)
    }
  }

  static var getThings: AppField<[Thing], NoArgs> {
    Field("getThings", at: Resolver.getThings)
  }

  static var createThing: AppField<Thing, InputArgs<CreateThingInput>> {
    Field("createThing", at: Resolver.createThing) {
      Argument("input", at: \\.input)
    }
  }

  static var createThings: AppField<[Thing], InputArgs<[CreateThingInput]>> {
    Field("createThings", at: Resolver.createThings) {
      Argument("input", at: \\.input)
    }
  }

  static var updateThing: AppField<Thing, InputArgs<UpdateThingInput>> {
    Field("updateThing", at: Resolver.updateThing) {
      Argument("input", at: \\.input)
    }
  }

  static var updateThings: AppField<[Thing], InputArgs<[UpdateThingInput]>> {
    Field("updateThings", at: Resolver.updateThings) {
      Argument("input", at: \\.input)
    }
  }

  static var deleteThing: AppField<Thing, IdentifyEntityArgs> {
    Field("deleteThing", at: Resolver.deleteThing) {
      Argument("id", at: \\.id)
    }
  }
}

extension Thing {
  convenience init(_ input: AppSchema.CreateThingInput) /* create_throws */ {
    self.init(/* CONVENIENCE_INIT_CREATE */)/* CONVENIENCE_INIT_CREATE_SETTERS */
  }

  convenience init(_ input: AppSchema.UpdateThingInput) /* update_init_throws */ {
    self.init(/* CONVENIENCE_INIT_UPDATE */)
  }

  func update(_ input: AppSchema.UpdateThingInput) /* update_func_throws */ {
    /* FUNC_UPDATE */
  }
}
`.trim();

function hasTry(code: string): boolean {
  return !!code.match(/\btry /);
}

function formatInit(parts: string[]): string {
  const totalLength = parts.join(`, `).length;
  if (totalLength > 80) {
    const joined = parts.join(`,\n      `);
    return `\n      ${joined}\n    `;
  }
  return parts.join(`, `);
}

function isSideLoaded(
  prop: Model['props'][0],
  model: Model,
  sideLoaded: Record<string, string>,
) {
  return sideLoaded[`${model.name}.${prop.name}`] === prop.type;
}