import { describe, it, test, expect } from '@jest/globals';
import stripIndent from 'strip-indent';
import { extractModelAttrs, extractModels } from '../model-attrs';

// remove comments `var title: String // @TODO remove`

describe(`extractModelAttrs()`, () => {
  it(`extracts basic props, ignoring computed properties`, () => {
    const source = stripIndent(/* swift */ `
    final class Thing {
      var id: Id
      var name: String
      var foo: String // @TODO remove
      var hasBeard: Bool { true }
      var kids = Children<Person>.notLoaded
      var createdAt = Current.date()
      var updatedAt: Date
      var deletedAt = Date()

      init(id: Id = .init(), name: String) {
        self.id = id;
        self.name = name;
      }
    } 
  `);

    const attrs = extractModelAttrs({ source, path: `/` });
    expect(attrs).toEqual({
      name: `Thing`,
      filepath: `/`,
      props: [
        { identifier: `id`, type: `Id` },
        { identifier: `name`, type: `String` },
        { identifier: `foo`, type: `String` },
        { identifier: `createdAt`, type: `Date` },
        { identifier: `updatedAt`, type: `Date` },
        { identifier: `deletedAt`, type: `Date` },
      ],
    });
  });
});

describe(`extractModels()`, () => {
  it(`extracts migration number (single migration)`, () => {
    const source1 = stripIndent(/* swift */ `
    final class Foobar {
      var id: UUID
    } 
  `);
    const source2 = stripIndent(/* swift */ `
    extension Foobar {
      enum M13 {
        static let tableName = "foobar"
      }
    } 
  `);

    const models = extractModels([
      { source: source1, path: `Foobar.swift` },
      { source: source2, path: `Foobar+Migration.swift` },
    ]);

    expect(models).toEqual([
      {
        name: `Foobar`,
        filepath: `Foobar.swift`,
        migrationNumber: 13,
        props: [{ identifier: `id`, type: `UUID` }],
      },
    ]);
  });

  it(`extracts migration number (double migration)`, () => {
    const source1 = stripIndent(/* swift */ `
    final class Foobar {
      var id: UUID
    } 
  `);
    const source2 = stripIndent(/* swift */ `
    extension Foobar {
      enum M12 {
        static let tableName = "foobar"
      }

      enum M15 {
        static let lol = "lol"
      }
    } 
  `);

    const models = extractModels([
      { source: source1, path: `Foobar.swift` },
      { source: source2, path: `Foobar+Migration.swift` },
    ]);

    expect(models).toEqual([
      {
        name: `Foobar`,
        filepath: `Foobar.swift`,
        migrationNumber: 12,
        props: [{ identifier: `id`, type: `UUID` }],
      },
    ]);
  });
});

// √ examine multiple files
// √ extract tablename migration for code gen
// generate conformances
// generate insert

// scaffold repository
// scaffold repository tests
// scaffold resolver
// scaffold resolver tests
// scaffold Current.db vars
