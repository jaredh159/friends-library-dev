import { snakeCase } from 'snake-case';
import { insertData, toPostgresData } from './model-db-data';
import { GlobalTypes } from '../types';
import Model from './Model';

export function generateModelConformances(
  model: Model,
  types: GlobalTypes,
): [filepath: string, code: string] {
  const { name, migrationNumber, props } = model;
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
  code += `extension ${name}: DuetModel {\n  static let tableName = ${table}\n}\n`;

  code += `\nextension ${name} {\n  typealias ColumnName = CodingKeys\n\n`;
  code += `  enum CodingKeys: String, CodingKey, CaseIterable {\n    `;
  code += props.map((p) => `case ${p.name}`).join(`\n    `);
  code += `\n  }\n}\n\n`;

  code += insertData(model, types) + `\n`;

  code += INSPECTABLE_PATTERN.replace(/Thing/g, model.name).replace(
    `// CASES_HERE`,
    model.props
      .flatMap((prop) => [
        `case .${prop.name}:`,
        `  return ${toPostgresData(
          prop,
          model,
          types,
          `forInspect`,
        )} == constraint.value`,
      ])
      .join(`\n      `),
  );

  if (props.some((p) => p.name == `createdAt` && p.type === `Date`)) {
    code += `\nextension ${name}: Auditable {}\n`;
  }
  if (props.some((p) => p.name == `updatedAt` && p.type === `Date`)) {
    code += `extension ${name}: Touchable {}\n`;
  }
  if (props.some((p) => p.name == `deletedAt` && p.type === `Date?`)) {
    code += `extension ${name}: SoftDeletable {}\n`;
  }

  return [`Sources/App/Models/Generated/${model.name}+Conformances.swift`, code];
}

function pascalToSnake(str: string): string {
  return str
    .trim()
    .split(/(?=[A-Z])/)
    .join('_')
    .toLowerCase();
}

const INSPECTABLE_PATTERN = /* swift */ `
extension Thing: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Thing>) -> Bool {
    switch constraint.column {
      // CASES_HERE
    }
  }
}
`;
