import { describe, it, test, expect } from '@jest/globals';
import stripIndent from 'strip-indent';
import { extractGlobalTypes, extractModelAttrs, extractModels } from '../model-attrs';

describe(`extractModelAttrs()`, () => {
  it(`extracts basic props, ignoring computed properties`, () => {
    const source = stripIndent(/* swift */ `
    final class Thing {
      var id: Id
      var name: String
      var foo: String // @TODO comment shouldn't interfere with extraction
      var parentId: Parent.Id
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

    const attrs = extractModelAttrs({ source, path: `/Models/Thing.swift` });
    expect(attrs).toEqual({
      name: `Thing`,
      filepath: `/Models/Thing.swift`,
      taggedTypes: {},
      props: [
        { identifier: `id`, type: `Id` },
        { identifier: `name`, type: `String` },
        { identifier: `foo`, type: `String` },
        { identifier: `parentId`, type: `Parent.Id` },
        { identifier: `createdAt`, type: `Date` },
        { identifier: `updatedAt`, type: `Date` },
        { identifier: `deletedAt`, type: `Date` },
      ],
    });
  });

  it(`can extract underlying types from tagged typealiases`, () => {
    const source = stripIndent(/* swift */ `
      final class Thing {
        var t1: Alias1
        var t2: Alias2?
        var t3: Alias3
      } 

      extension Thing {
        typealias Alias1 = Tagged<Thing, UUID>
        typealias Alias2 = Tagged<(thing: Thing, t2: ()), Int>
        typealias Alias3 = Tagged<Thing, String>
      }
  `);

    const model = extractModelAttrs({ source, path: `/Models/Thing.swift` });
    expect(model?.taggedTypes).toEqual({
      Alias1: `UUID`,
      Alias2: `Int`,
      Alias3: `String`,
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
      { source: source1, path: `/Models/Foobar.swift` },
      { source: source2, path: `/Models/Foobar+Migration.swift` },
    ]);

    expect(models).toEqual([
      {
        name: `Foobar`,
        filepath: `/Models/Foobar.swift`,
        migrationNumber: 13,
        taggedTypes: {},
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
      { source: source1, path: `/Models/Foobar.swift` },
      { source: source2, path: `/Models/Foobar+Migration.swift` },
    ]);

    expect(models).toEqual([
      {
        name: `Foobar`,
        filepath: `/Models/Foobar.swift`,
        migrationNumber: 12,
        taggedTypes: {},
        props: [{ identifier: `id`, type: `UUID` }],
      },
    ]);
  });
});

describe(`extractGlobalTypes()`, () => {
  it(`can extract dbEnums and taggedTypes`, () => {
    const source = stripIndent(/* swift */ `
      enum FooEnum: String, Codable, CaseIterable {
        case foo
        case bar
      }

      enum SkipMe {
        case lol
      }

      typealias Foo = Tagged<(tagged: (), foo: ()), String>
      typealias Bar = Tagged<(tagged: (), bar: ()), Int>
    `);

    const types = extractGlobalTypes([source]);

    expect(types).toEqual({
      dbEnums: [`FooEnum`],
      taggedTypes: { Foo: `String`, Bar: `Int` },
    });
  });
});
