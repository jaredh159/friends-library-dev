import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { generateModelMocks } from '../model-mocks';

describe(`generateModelMocks()`, () => {
  const globalTypes = {
    dbEnums: { FooEnum: [`foo`, `bar`] },
    taggedTypes: { GitCommitSha: `String`, Foo: `Int` },
  };

  it(`can handle a short list of init params`, () => {
    const model = {
      name: `Thing`,
      filepath: `/`,
      taggedTypes: { FooId: `Int`, PaymentId: `String` },
      dbEnums: {},
      props: [
        { name: `id`, type: `Id` },
        { name: `name`, type: `String` },
      ],
      init: [
        { propName: `id`, hasDefault: true },
        { propName: `name`, hasDefault: false },
      ],
    };

    const expectedMocks = stripIndent(/* swift */ `
      // auto-generated, do not edit
      @testable import App
      
      extension Thing {
        static var mock: Thing {
          Thing(name: "@mock name")
        }
      
        static var empty: Thing {
          Thing(name: "")
        }
      }
    `).trim();

    const [filepath, sourceCode] = generateModelMocks(model, globalTypes);
    expect(filepath).toBe(`Tests/AppTests/Mocks/Thing+Mocks.swift`);
    expect(sourceCode).toBe(expectedMocks + `\n`);
  });

  it(`can handle a long list of init params`, () => {
    const model = {
      name: `Thing`,
      filepath: `/`,
      dbEnums: { JimJam: [`jim`, `jam`] },
      taggedTypes: { FooId: `Int`, PaymentId: `String` },
      props: [
        { name: `id`, type: `Id` },
        { name: `name`, type: `String` },
        { name: `someInt`, type: `Int` },
        { name: `someBool`, type: `Bool` },
        { name: `someEmail`, type: `EmailAddress` },
        { name: `someSha`, type: `GitCommitSha` },
        { name: `someNil`, type: `Rofl?` },
        { name: `fooId`, type: `FooId` },
        { name: `relationId`, type: `Relation.Id` },
        { name: `seconds`, type: `Seconds<Double>` },
        { name: `nonEmptyInt`, type: `NonEmpty<[Int]>` },
        { name: `someFoo`, type: `FooEnum` },
        { name: `jimJam`, type: `JimJam` },
      ],
      init: [
        { propName: `id`, hasDefault: true },
        { propName: `name`, hasDefault: false },
        { propName: `someInt`, hasDefault: false },
        { propName: `someBool`, hasDefault: false },
        { propName: `someEmail`, hasDefault: false },
        { propName: `someSha`, hasDefault: false },
        { propName: `someNil`, hasDefault: false },
        { propName: `fooId`, hasDefault: false },
        { propName: `relationId`, hasDefault: false },
        { propName: `seconds`, hasDefault: false },
        { propName: `nonEmptyInt`, hasDefault: false },
        { propName: `someFoo`, hasDefault: false },
        { propName: `jimJam`, hasDefault: false },
      ],
    };

    const expectedMocks = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import NonEmpty
      
      @testable import App
      
      extension Thing {
        static var mock: Thing {
          Thing(
            name: "@mock name",
            someInt: 42,
            someBool: true,
            someEmail: "mock@mock.com",
            someSha: "@mock someSha",
            someNil: nil,
            fooId: .init(rawValue: 42),
            relationId: .init(),
            seconds: 42,
            nonEmptyInt: NonEmpty<[Int]>(42),
            someFoo: .foo,
            jimJam: .jim
          )
        }
      
        static var empty: Thing {
          Thing(
            name: "",
            someInt: 0,
            someBool: false,
            someEmail: "",
            someSha: "",
            someNil: nil,
            fooId: .init(rawValue: 0),
            relationId: .init(),
            seconds: 0,
            nonEmptyInt: NonEmpty<[Int]>(0),
            someFoo: .foo,
            jimJam: .jim
          )
        }
      }
    `).trim();

    const [filepath, sourceCode] = generateModelMocks(model, globalTypes);
    expect(filepath).toBe(`Tests/AppTests/Mocks/Thing+Mocks.swift`);
    expect(sourceCode).toBe(expectedMocks + `\n`);
  });
});
