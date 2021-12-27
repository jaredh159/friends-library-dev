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

      extension Thing {
        typealias ColumnName = CodingKeys

        enum CodingKeys: String, CodingKey {
          case id
          case version
        }
      }
    `).trim();

    const [path, code] = generateModelConformances(model);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Thing+Conformances.swift`);
  });

  it(`generates correct timestamp conformances`, () => {
    const model = {
      name: `Thing`,
      filepath: `Sources/App/Models/Thing.swift`,
      props: [
        { identifier: `createdAt`, type: `Date` },
        { identifier: `updatedAt`, type: `Date` },
        { identifier: `deletedAt`, type: `Date?` },
      ],
    };

    const expectedCode = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import Foundation

      extension Thing: AppModel {}

      extension Thing: DuetModel {
        static let tableName = "things"
      }

      extension Thing {
        typealias ColumnName = CodingKeys

        enum CodingKeys: String, CodingKey {
          case createdAt
          case updatedAt
          case deletedAt
        }
      }

      extension Thing: Auditable {}
      extension Thing: Touchable {}
      extension Thing: SoftDeletable {}
    `).trim();

    const [path, code] = generateModelConformances(model);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Thing+Conformances.swift`);
  });
});
