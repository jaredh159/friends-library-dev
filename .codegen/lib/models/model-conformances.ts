import { insertData, toPostgresData } from './model-db-data';
import { GlobalTypes } from '../types';
import Model from './Model';

export function generateModelConformances(
  model: Model,
  types: GlobalTypes,
): [filepath: string, code: string] {
  const { name, migrationNumber, props } = model;
  let code = `// auto-generated, do not edit\nimport DuetSQL\n`;

  let needsIdAlias = false;
  if (props.some((p) => p.type == `Id`)) {
    code += `import Tagged\n`;
    needsIdAlias = true;
  }

  code += `\n`;

  code += `extension ${name}: ApiModel {`;
  if (needsIdAlias) {
    code += `\n  typealias Id = Tagged<${name}, UUID>\n`;
  }
  code += `}\n\n`;

  const table = migrationNumber
    ? `M${migrationNumber}.tableName`
    : `"${pascalToSnake(name)}s"`;

  let isSoftDeletable = !!model.props.find((p) => p.name === `deletedAt`);
  code += `extension ${name}: Model {\n  static let tableName = ${table}\n`;
  code += `  static var isSoftDeletable: Bool { ${isSoftDeletable} }\n`;
  code += `}\n`;

  code += `\nextension ${name} {\n  typealias ColumnName = CodingKeys\n\n`;
  code += `  enum CodingKeys: String, CodingKey, CaseIterable {\n    `;
  code += props.map((p) => `case ${p.name}`).join(`\n    `);
  code += `\n  }\n}\n\n`;

  code += insertData(model, types) + `\n`;

  code += INSPECTABLE_PATTERN.replace(/Thing/g, model.name).replace(
    `// CASES_HERE`,
    model.props
      .flatMap((prop) => {
        const data = toPostgresData(prop, model, types, `forInspect`);
        return [`case .${prop.name}:`, `  return constraint.isSatisfiedBy(${data})`];
      })
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
