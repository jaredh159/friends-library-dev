import { File, GlobalTypes } from '../types';
import Model from './Model';

export function extractModelAttrs({ source, path }: File): Model | undefined {
  if (
    (!path.includes(`/Models/`) && !path.includes(`/Migrations/`)) ||
    path.includes(`+`) ||
    path.includes(`Repository`) ||
    path.includes(`Resolver`)
  ) {
    return undefined;
  }

  let model: Model | undefined = undefined;
  const lines = source.split(`\n`);
  while (lines.length) {
    const line = lines.shift()!;
    const classMatch = line.match(/^(?:final )?class ([A-Z][^\s]+)(: Codable)? {$/);
    if (classMatch !== null) {
      model = parseClassInterior(classMatch[1], path, lines);
    }
    if (model && line.startsWith(`extension ${model.name} {`)) {
      extractFromModelExtension(model, lines);
    }
  }
  return model;
}

function parseClassInterior(name: string, path: string, lines: string[]): Model {
  const model = new Model(name, path);

  while (lines.length) {
    const line = lines.shift()!;

    if (line.startsWith(`}`)) {
      return model;
    }

    if (line.startsWith(`  init`)) {
      parseInit(model, line, lines);
      continue;
    }

    if (!line.startsWith(`  var `)) {
      continue;
    }

    // relations
    const relationMatch = line.match(/\s+var ([^ ]+) = ([^ <]+)<([^>]+)>.notLoaded/);
    if (relationMatch) {
      const [, name = ``, relationType = ``, type = ``] = relationMatch;
      model.relations[name] = { relationType: relationType, type };
      continue;
    }

    // computed property
    const computedPropMatch = line.match(/\s+var ([^ ]+):\s+([^ ]+)\s+{/);
    if (computedPropMatch) {
      const computedProp = { name: computedPropMatch[1], type: computedPropMatch[2] };
      model.computedProps.push(computedProp);
      continue;
    }

    const tzMatch = line.match(/var ((?:crea|upda|dele)tedAt)/);
    if (tzMatch !== null) {
      model.props.push({ name: tzMatch[1], type: `Date` });
      continue;
    }

    const [name, type] = line
      .replace(/\s+\/\/.*/, ``)
      .trim()
      .replace(/^var /, ``)
      .split(`: `, 2);
    model.props.push({ name, type });
  }

  return model;
}

function parseInit(model: Model, line: string, lines: string[]): void {
  let slicedLine = line.slice(7);
  if (slicedLine == ``) {
    while (lines.length) {
      const line = lines.shift()!;
      if (line.trim().startsWith(`)`)) {
        return;
      }
      const match = line.match(/\s*([a-z0-9]+): (.*)/i);
      if (!match) {
        throw new Error(`Unable to parse init() for model: ${model.name}, ${line}`);
      }
      const [, propName = ``, rest = ``] = match;
      model.init.push({ propName, hasDefault: rest.includes(`=`) });
    }
  } else {
    slicedLine = slicedLine.replace(/\)\s+{$/, ``);
    return parseInit(model, `  init(`, [...slicedLine.split(/,\s+/g), `  ) {`]);
  }
}

export function setMigrationNumbers(
  { source }: File,
  models: Record<string, Model>,
): void {
  const lines = source.split(`\n`);
  while (lines.length) {
    const line = lines.shift()!;
    const extensionMatch = line.match(/^extension ([A-Z][A-Za-z0-9]+) {$/);
    if (extensionMatch && models[extensionMatch[1]]) {
      setMigrationNumber(models[extensionMatch[1]], lines);
    }
  }
}

function setMigrationNumber(model: Model, lines: string[]): void {
  let inMigration: number | null = null;
  while (lines.length) {
    const line = lines.shift()!;
    if (line.startsWith(`}`)) {
      return;
    }
    const migrationMatch = line.match(/^  enum M(\d+) {$/);
    if (migrationMatch && !Number.isNaN(Number(migrationMatch[1]))) {
      inMigration = Number(migrationMatch[1]);
    }
    if (inMigration && line.startsWith(`    static let tableName =`)) {
      model.migrationNumber = inMigration;
    }
  }
}

function setIsPreloaded({ source }: File, models: Record<string, Model>): void {
  if (!source.includes(`enum PreloadedEntityType {`)) {
    return;
  }
  const lines = source.split(`\n`);
  while (lines.length) {
    const line = lines.shift()!;
    if (line.match(/^enum PreloadedEntityType {$/)) {
      parsePreloadedEntityTypes(lines, models);
    }
  }
}

function parsePreloadedEntityTypes(lines: string[], models: Record<string, Model>) {
  while (lines.length && lines[0] !== `}`) {
    const line = lines.shift()!;
    const match = line.match(/^\s+case [^)]+\(([A-Z][A-Za-z]+)\.Type\)$/);
    if (!match) {
      continue;
    }
    const modelName = match[1];
    const model = models[modelName];
    if (!model) throw new Error(`Unexpected model name from PreloadedEntityType enum`);
    model.isPreloaded = true;
  }
}

export function extractModels(files: File[]): Model[] {
  const models: Record<string, Model> = {};
  for (const file of files) {
    const model = extractModelAttrs(file);
    if (model) {
      models[model.name] = model;
    }
  }

  for (const file of files) {
    setMigrationNumbers(file, models);
    setIsPreloaded(file, models);
  }

  return Object.values(models);
}

export function extractGlobalTypes(sources: string[]): GlobalTypes {
  const types: GlobalTypes = {
    dbEnums: {},
    taggedTypes: {},
  };

  for (const source of sources) {
    const lines = source.split(`\n`);
    while (lines.length) {
      const line = lines.shift()!;
      extractDbEnum(line, lines, types.dbEnums, `global`);
      extractTaggedType(types, line);
    }
  }

  return types;
}

function extractDbEnum(
  line: string,
  lines: string[],
  dbEnums: Record<string, string[]>,
  context: 'global' | 'nested',
): void {
  const enumMatch = line.match(
    /\s*enum ([^: ]+): String, Codable, CaseIterable(, Equatable)? {/,
  );
  if (!enumMatch) {
    return;
  }
  if (context === `global` && line.startsWith(` `)) {
    return;
  }
  if (context === `nested` && line.startsWith(`enum`)) {
    return;
  }

  const enumName = enumMatch[1];
  dbEnums[enumName] = extractDbEnumCases(lines);
}

function extractDbEnumCases(lines: string[]): string[] {
  const cases: string[] = [];
  while (lines.length) {
    const line = lines.shift()!;
    if (line.match(/^\s*}/)) {
      return cases;
    }
    const caseMatch = line.match(/  case ([a-z0-9]+)$/i);
    if (caseMatch) {
      cases.push(caseMatch[1]);
    }
  }
  return cases;
}

function extractFromModelExtension(model: Model, lines: string[]): void {
  while (lines.length) {
    const line = lines.shift()!;
    if (line === `}`) {
      return;
    }

    if (line.startsWith(`  typealias `)) {
      extractTaggedType(model, line);
      continue;
    }

    extractDbEnum(line, lines, model.dbEnums, `nested`);
  }
}

function extractTaggedType(
  obj: { taggedTypes: Record<string, string> },
  line: string,
): void {
  const match = line.match(/\s*typealias ([^ ]+) = Tagged<(.+)>$/);
  if (!match) {
    return;
  }

  const alias = match[1];
  const innerParts = match[2].split(`, `);
  const taggedType = innerParts.pop() ?? ``;
  obj.taggedTypes[alias] = taggedType;
}
