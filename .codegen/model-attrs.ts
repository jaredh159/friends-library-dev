import { Model, File, GlobalTypes } from './types';

export function extractModelAttrs({ source, path }: File): Model | undefined {
  if (
    !path.includes(`/Models/`) ||
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
      extractModelTaggedTypes(model, lines);
    }
  }
  return model;
}

function parseClassInterior(name: string, path: string, lines: string[]): Model {
  const attrs: Model = { name: name, filepath: path, props: [], taggedTypes: {} };
  while (lines.length) {
    const line = lines.shift()!;
    if (line.startsWith(`}`)) {
      return attrs;
    }

    if (!line.startsWith(`  var `)) {
      continue;
    }

    // relations
    if (line.endsWith(`.notLoaded`)) {
      continue;
    }

    // computed property
    if (line.match(/ ({|})$/)) {
      continue;
    }

    const tzMatch = line.match(/var ((?:crea|upda|dele)tedAt)/);
    if (tzMatch !== null) {
      attrs.props.push({ identifier: tzMatch[1], type: `Date` });
      continue;
    }

    const [identifier, type] = line
      .replace(/\s+\/\/.*/, ``)
      .trim()
      .replace(/^var /, ``)
      .split(`: `, 2);
    attrs.props.push({ identifier, type });
  }
  return attrs;
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
  }

  return Object.values(models);
}

export function extractGlobalTypes(sources: string[]): GlobalTypes {
  const types: GlobalTypes = {
    dbEnums: [],
    taggedTypes: {},
  };

  for (const source of sources) {
    for (const line of source.split(`\n`)) {
      const enumMatch = line.match(/^enum ([^: ]+): String, Codable, CaseIterable {/);
      if (enumMatch) {
        types.dbEnums.push(enumMatch[1]);
      }
      extractTaggedType(types, line);
    }
  }

  return types;
}

function extractModelTaggedTypes(model: Model, lines: string[]): void {
  while (lines.length) {
    const line = lines.shift()!;
    if (line === `}`) {
      return;
    }

    if (!line.startsWith(`  typealias `)) {
      continue;
    }

    extractTaggedType(model, line);
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
