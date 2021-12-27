import { Model, File } from './types';

export function extractModelAttrs({ source, path }: File): Model | undefined {
  const lines = source.split(`\n`);
  while (lines.length) {
    const line = lines.shift()!;
    const classMatch = line.match(/^(?:final )?class ([A-Z][^\s]+)(: Codable)? {$/);
    if (classMatch !== null) {
      return parseClassInterior(classMatch[1], path, lines);
    }
  }
  return undefined;
}

function parseClassInterior(name: string, path: string, lines: string[]): Model {
  const attrs: Model = { name: name, filepath: path, props: [] };
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
