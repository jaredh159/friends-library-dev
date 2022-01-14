import { describe, it, expect } from '@jest/globals';
import stripIndent from 'strip-indent';
import { generateModelConformances } from '../model-conformances';
import Model from '../Model';

describe(`generateModelConformances()`, () => {
  const types = {
    dbEnums: { FooEnum: [`foo`] },
    taggedTypes: { GitCommitSha: `String`, Foo: `Int` },
  };

  it(`generates correct conformances for models`, () => {
    const model = Model.mock();
    model.migrationNumber = 8;
    model.props = [
      { name: `id`, type: `Id` },
      { name: `name`, type: `String` },
      { name: `version`, type: `GitCommitSha` },
    ];

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
          case name
          case version
        }
      }

      extension Thing {
        var insertValues: [ColumnName: Postgres.Data] {
          [
            .id: .id(self),
            .name: .string(name),
            .version: .string(version.rawValue),
          ]
        }
      }

      extension Thing: SQLInspectable {
        func satisfies(constraint: SQL.WhereConstraint) -> Bool {
          switch constraint.column {
            case "id":
              return .id(self) == constraint.value
            case "name":
              return .string(name) == constraint.value
            case "version":
              return .string(version.rawValue) == constraint.value
            default:
              return false
          }
        }
      }
    `).trim();

    const [path, code] = generateModelConformances(model, types);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Generated/Thing+Conformances.swift`);
  });

  it(`generates correct timestamp conformances`, () => {
    const model = Model.mock();
    model.props = [
      { name: `createdAt`, type: `Date` },
      { name: `updatedAt`, type: `Date` },
      { name: `deletedAt`, type: `Date?` },
    ];

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

      extension Thing {
        var insertValues: [ColumnName: Postgres.Data] {
          [
            .createdAt: .currentTimestamp,
            .updatedAt: .currentTimestamp,
          ]
        }
      }
      
      extension Thing: SQLInspectable {
        func satisfies(constraint: SQL.WhereConstraint) -> Bool {
          switch constraint.column {
            case "created_at":
              return .date(createdAt) == constraint.value
            case "updated_at":
              return .date(updatedAt) == constraint.value
            case "deleted_at":
              return .date(deletedAt) == constraint.value
            default:
              return false
          }
        }
      }

      extension Thing: Auditable {}
      extension Thing: Touchable {}
      extension Thing: SoftDeletable {}
    `).trim();

    const [path, code] = generateModelConformances(model, types);
    expect(code).toBe(expectedCode + `\n`);
    expect(path).toBe(`Sources/App/Models/Generated/Thing+Conformances.swift`);
  });
});
