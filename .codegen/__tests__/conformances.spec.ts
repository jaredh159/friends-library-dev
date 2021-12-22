import { describe, it, test, expect } from '@jest/globals';
import stripIndent from 'strip-indent';
import { generateModelConformances } from '../conformances';

describe(`generateModelConformances()`, () => {
  it(`generates correct conformances for models`, () => {
    const model = {
      name: `Thing`,
      filepath: `Sources/App/Models/Thing.swift`,
      migrationNumber: 8,
      props: [
        { identifier: `id`, type: `Id` },
        { identifier: `version`, type: `GitCommitSha` },
        { identifier: `createdAt`, type: `Date` },
      ],
    };

    const expectedCode = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import Foundation
      import Tagged

      extension Thing: AppModel {
        typealias Id = Tagged<Thing, UUID>
      }

      extension Thing: DuetModel {
        static let tableName = M8.tableName
      }

      extension Thing: Codable {
        typealias ColumnName = CodingKeys

        enum CodingKeys: String, CodingKey {
          case id
          case version
          case createdAt
        }
      }
    `).trim();

    const [path, code] = generateModelConformances(model);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Thing+Conformances.swift`);
  });
});
