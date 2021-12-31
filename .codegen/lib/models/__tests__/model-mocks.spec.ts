import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { generateModelMocks } from '../model-mocks';
import Model from '../Model';

describe(`generateModelMocks()`, () => {
  const globalTypes = {
    dbEnums: { FooEnum: [`foo`, `bar`] },
    taggedTypes: { GitCommitSha: `String`, Foo: `Int` },
  };

  const model = Model.mock();
  model.dbEnums = { JimJam: [`jim`, `jam`] };
  model.taggedTypes = { FooId: `Int`, PaymentId: `String` };
  model.props = [
    { name: `id`, type: `Id` },
    { name: `name`, type: `String` },
    { name: `someInt`, type: `Int` },
    { name: `someBool`, type: `Bool` },
    { name: `someEmail`, type: `EmailAddress` },
    { name: `someSha`, type: `GitCommitSha` },
    { name: `someNil`, type: `String?` },
    { name: `fooId`, type: `FooId` },
    { name: `relationId`, type: `Relation.Id` },
    { name: `seconds`, type: `Seconds<Double>` },
    { name: `nonEmptyInt`, type: `NonEmpty<[Int]>` },
    { name: `someFoo`, type: `FooEnum` },
    { name: `jimJam`, type: `JimJam` },
  ];
  model.init = [
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
  ];

  it(`can handle a short list of init params`, () => {
    const model = Model.mock();
    model.taggedTypes = { FooId: `Int`, PaymentId: `String` };
    model.props = [
      { name: `id`, type: `Id` },
      { name: `name`, type: `String` },
    ];
    model.init = [
      { propName: `id`, hasDefault: true },
      { propName: `name`, hasDefault: false },
    ];

    const expectedMocks = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import GraphQL

      @testable import App
      
      extension Thing {
        static var mock: Thing {
          Thing(name: "@mock name")
        }
      
        static var empty: Thing {
          Thing(name: "")
        }

        static var random: Thing {
          Thing(name: "@random".random)
        }
      
        func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
          var map: GraphQL.Map = .dictionary([
            "id": .string(id.rawValue.uuidString),
            "name": .string(name),
          ])
          omitting.forEach { try? map.remove($0) }
          return map
        }
      }
    `).trim();

    const [filepath, sourceCode] = generateModelMocks(model, globalTypes);
    expect(filepath).toBe(`Tests/AppTests/Mocks/Thing+Mocks.swift`);
    expect(sourceCode).toBe(expectedMocks + `\n`);
  });

  it(`can handle a long list of init params`, () => {
    const expectedMocks = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import GraphQL
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
      
        static var random: Thing {
          Thing(
            name: "@random".random,
            someInt: Int.random,
            someBool: Bool.random(),
            someEmail: .init(rawValue: "@random".random),
            someSha: .init(rawValue: "@random".random),
            someNil: Bool.random() ? "@random".random : nil,
            fooId: .init(rawValue: Int.random),
            relationId: .init(),
            seconds: .init(rawValue: Double.random(in: 100...999)),
            nonEmptyInt: NonEmpty<[Int]>(Int.random),
            someFoo: FooEnum.allCases.shuffled().first!,
            jimJam: JimJam.allCases.shuffled().first!
          )
        }

        func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
          var map: GraphQL.Map = .dictionary([
            "id": .string(id.rawValue.uuidString),
            "name": .string(name),
            "someInt": .number(Number(someInt)),
            "someBool": .bool(someBool),
            "someEmail": .string(someEmail.rawValue),
            "someSha": .string(someSha.rawValue),
            "someNil": someNil != nil ? .string(someNil!) : .null,
            "fooId": .number(Number(fooId.rawValue)),
            "relationId": .string(relationId.rawValue.uuidString),
            "seconds": .number(Number(seconds.rawValue)),
            "nonEmptyInt": .array(nonEmptyInt.array.map { .number(Number($0)) }),
            "someFoo": .string(someFoo.rawValue),
            "jimJam": .string(jimJam.rawValue),
          ])
          omitting.forEach { try? map.remove($0) }
          return map
        }
      }
    `).trim();

    const [filepath, sourceCode] = generateModelMocks(model, globalTypes);
    expect(filepath).toBe(`Tests/AppTests/Mocks/Thing+Mocks.swift`);
    expect(sourceCode).toBe(expectedMocks + `\n`);
  });
});
