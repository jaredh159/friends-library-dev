import { describe, it, test, expect } from '@jest/globals';
import stripIndent from 'strip-indent';
import { generateModelConformances } from '../model-conformances';

describe(`generateModelConformances()`, () => {
  const types = {
    dbEnums: [`FooEnum`],
    taggedTypes: { GitCommitSha: `String`, Foo: `Int` },
  };

  it(`generates correct conformances for models`, () => {
    const model = {
      name: `Thing`,
      filepath: `Sources/App/Models/Thing.swift`,
      migrationNumber: 8,
      props: [
        { identifier: `id`, type: `Id` },
        { identifier: `name`, type: `String` },
        { identifier: `version`, type: `GitCommitSha` },
      ],
      taggedTypes: {},
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
        var insertValues: [String: Postgres.Data] {
          [
            Self[.id]: .id(self),
            Self[.name]: .string(name),
            Self[.version]: .string(version.rawValue),
          ]
        }
      }

      extension Thing {
        typealias ColumnName = CodingKeys

        enum CodingKeys: String, CodingKey {
          case id
          case name
          case version
        }
      }
    `).trim();

    const [path, code] = generateModelConformances(model, types);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Thing+Conformances.swift`);
  });

  it(`generates correct timestamp conformances`, () => {
    const model = {
      name: `Thing`,
      filepath: `Sources/App/Models/Thing.swift`,
      taggedTypes: {},
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
        var insertValues: [String: Postgres.Data] {
          [
            Self[.createdAt]: .currentTimestamp,
            Self[.updatedAt]: .currentTimestamp,
          ]
        }
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

    const [path, code] = generateModelConformances(model, types);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Thing+Conformances.swift`);
  });
});
