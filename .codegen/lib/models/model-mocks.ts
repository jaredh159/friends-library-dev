import { GlobalTypes } from '../types';
import Model from './Model';

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

  code += `\n\n  static var random: ${model.name} {\n    ${model.name}(`;
  const randomParams = params(model, globalTypes, `random`);
  if (randomParams.join(`, `).length < 80) {
    code += randomParams.join(`, `);
    code += `)\n  }`;
  } else {
    code += `\n      `;
    code += randomParams.join(`,\n      `);
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
  type: 'empty' | 'mock' | 'random',
): string[] {
  return model.init
    .filter((p) => !p.hasDefault)
    .map(({ propName }) => {
      const prop = model.props.find((p) => p.name == propName);
      if (!prop) {
        throw new Error(`Error resolving init param type for ${model.name}.${propName}`);
      }
      const values = mockValue(prop.type, propName, model, globalTypes);
      return `${propName}: ${values[type]}`;
    });
}

function mockValue(
  type: string,
  propName: string,
  model: Model,
  globalTypes: GlobalTypes,
): { mock: string; empty: string; random: string } {
  if (type.endsWith(`?`)) {
    return { mock: `nil`, empty: `nil`, random: `nil` };
  }

  const dbEnum = model.dbEnums[type] || globalTypes.dbEnums[type];
  if (dbEnum) {
    return {
      mock: `.${dbEnum[0]}`,
      empty: `.${dbEnum[0]}`,
      random: `${type}.allCases.shuffled().first!`,
    };
  }

  switch (type) {
    case `String`:
      return { mock: `"@mock ${propName}"`, empty: `""`, random: `"@random".random` };
    case `Int`:
      return { mock: `42`, empty: `0`, random: `Int.random` };
    case `Int64`:
      return { mock: `42`, empty: `0`, random: `Int64.random` };
    case `Seconds<Double>`:
      return {
        mock: `42`,
        empty: `0`,
        random: `.init(rawValue: Double.random(in: 100...999))`,
      };
    case `Cents<Int>`:
      return { mock: `42`, empty: `0`, random: `.init(rawValue: Int.random)` };
    case `NonEmpty<[Int]>`:
      return {
        mock: `NonEmpty<[Int]>(42)`,
        empty: `NonEmpty<[Int]>(0)`,
        random: `NonEmpty<[Int]>(Int.random)`,
      };
    case `Bool`:
      return { mock: `true`, empty: `false`, random: `Bool.random()` };
    case `EmailAddress`:
      return {
        mock: `"mock@mock.com"`,
        empty: `""`,
        random: `.init(rawValue: "@random".random)`,
      };
    case `GitCommitSha`:
      return {
        mock: `"@mock ${propName}"`,
        empty: `""`,
        random: `.init(rawValue: "@random".random)`,
      };
    default: {
      const taggedType = model.taggedTypes[type] || globalTypes.taggedTypes[type];
      if (taggedType) {
        const { mock, empty, random } = mockValue(
          taggedType,
          propName,
          model,
          globalTypes,
        );
        return {
          mock: `.init(rawValue: ${mock})`,
          empty: `.init(rawValue: ${empty})`,
          random: `.init(rawValue: ${random})`,
        };
      }

      if (type.endsWith(`.Id`) || type === `UUID`) {
        return { mock: `.init()`, empty: `.init()`, random: `.init()` };
      }
      throw new Error(`Unhandled init param mock value type: ${type}`);
    }
  }
}
