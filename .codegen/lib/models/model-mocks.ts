import { GlobalTypes, Model } from '../types';

export function generateModelMocks(
  model: Model,
  globalTypes: GlobalTypes,
): [filepath: string, code: string] {
  const mockParams = params(model, globalTypes, `mock`);
  let code = ``;
  code += `@testable import App\n\nextension ${model.name} {\n  `;
  code += `static var mock: ${model.name} {\n    ${model.name}(`;
  if (mockParams.join(`, `).length < 80) {
    code += mockParams.join(`, `);
    code += `)\n  }`;
  } else {
    code += `\n      `;
    code += mockParams.join(`,\n      `);
    code += `\n    )\n  }`;
  }

  code += `\n\n  static var empty: ${model.name} {\n    ${model.name}(`;
  const emptyParams = params(model, globalTypes, `empty`);
  if (emptyParams.join(`, `).length < 80) {
    code += emptyParams.join(`, `);
    code += `)\n  }`;
  } else {
    code += `\n      `;
    code += emptyParams.join(`,\n      `);
    code += `\n    )\n  }`;
  }

  code += `\n}\n`;

  if (code.includes(`NonEmpty<`)) {
    code = `// auto-generated, do not edit\nimport NonEmpty\n\n${code}`;
  } else {
    code = `// auto-generated, do not edit\n${code}`;
  }

  return [`Tests/AppTests/Mocks/${model.name}+Mocks.swift`, code];
}

function params(
  model: Model,
  globalTypes: GlobalTypes,
  type: 'empty' | 'mock',
): string[] {
  return model.init
    .filter((p) => !p.hasDefault)
    .map(({ propName }) => {
      const prop = model.props.find((p) => p.name == propName);
      if (!prop) {
        throw new Error(`Error resolving init param type for ${model.name}.${propName}`);
      }
      const value = mockValue(prop.type, propName, model, globalTypes)[
        type === `mock` ? 0 : 1
      ];
      return `${propName}: ${value}`;
    });
}

function mockValue(
  type: string,
  propName: string,
  model: Model,
  globalTypes: GlobalTypes,
): [mock: string, empty: string] {
  if (type.endsWith(`?`)) {
    return [`nil`, `nil`];
  }

  const dbEnum = model.dbEnums[type] || globalTypes.dbEnums[type];
  if (dbEnum) {
    return [`.${dbEnum[0]}`, `.${dbEnum[0]}`];
  }

  switch (type) {
    case `String`:
      return [`"@mock ${propName}"`, `""`];
    case `Int`:
    case `Int64`:
    case `Seconds<Double>`:
    case `Cents<Int>`:
      return [`42`, `0`];
    case `NonEmpty<[Int]>`:
      return [`NonEmpty<[Int]>(42)`, `NonEmpty<[Int]>(0)`];
    case `Bool`:
      return [`true`, `false`];
    case `EmailAddress`:
      return [`"mock@mock.com"`, `""`];
    case `GitCommitSha`:
      return [`"@mock ${propName}"`, `""`];
    default: {
      const taggedType = model.taggedTypes[type] || globalTypes.taggedTypes[type];
      if (taggedType) {
        const [mock, empty] = mockValue(taggedType, propName, model, globalTypes);
        return [`.init(rawValue: ${mock})`, `.init(rawValue: ${empty})`];
      }

      if (type.endsWith(`.Id`)) {
        return [`.init()`, `.init()`];
      }
      throw new Error(`Unhandled init param mock value type: ${type}`);
    }
  }
}
