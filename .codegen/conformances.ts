import { Model } from './types';

export function generateModelConformances(
  model: Model,
): [filepath: string, code: string] {
  const { name, migrationNumber, filepath, props } = model;
  let code = `// auto-generated, do not edit\nimport Foundation\n`;

  let needsIdAlias = false;
  if (props.some((p) => p.type == `Id`)) {
    code += `import Tagged\n`;
    needsIdAlias = true;
  }

  code += `\n`;

  code += `extension ${name}: AppModel {`;
  if (needsIdAlias) {
    code += `\n  typealias Id = Tagged<${name}, UUID>\n}\n\n`;
  } else {
    code += `}\n\n`;
  }

  const table = migrationNumber
    ? `M${migrationNumber}.tableName`
    : `"${pascalToSnake(name)}s"`;
  code += `extension ${name}: DuetModel {\n  static let tableName = ${table}\n}\n\n`;

  code += `extension ${name} {\n  typealias ColumnName = CodingKeys\n\n`;
  code += `  enum CodingKeys: String, CodingKey {\n    `;
  code += props.map((p) => `case ${p.identifier}`).join(`\n    `);
  code += `\n  }\n}\n`;

  if (props.some((p) => p.identifier == `createdAt` && p.type === `Date`)) {
    code += `\nextension ${name}: Auditable {}\n`;
  }
  if (props.some((p) => p.identifier == `updatedAt` && p.type === `Date`)) {
    code += `extension ${name}: Touchable {}\n`;
  }
  if (props.some((p) => p.identifier == `deletedAt` && p.type === `Date?`)) {
    code += `extension ${name}: SoftDeletable {}\n`;
  }

  const path = filepath.replace(`.swift`, `+Conformances.swift`);
  return [path, code];
}

function pascalToSnake(str: string): string {
  return str
    .trim()
    .split(/(?=[A-Z])/)
    .join('_')
    .toLowerCase();
}
