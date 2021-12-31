import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { GlobalTypes } from '../../types';
import {
  generateModelGraphQLTypes,
  schemaTypeFieldParts,
  modelTypeToGraphQLInputType,
  modelPropToInitArg,
} from '../graphql';
import Model from '../Model';

const types: GlobalTypes = {
  dbEnums: {},
  taggedTypes: {
    Id: 'UUID',
    ExternalPlaylistId: 'Int64',
    ExternalId: 'Int64',
    PaymentId: 'String',
    PrintJobId: 'Int',
    Value: 'UUID',
    GitCommitSha: 'String',
    ISBN: 'String',
    Bytes: 'Int',
    EmailAddress: 'String',
  },
};

const model = Model.mock();
model.dbEnums = { FooBar: [`foo`, `bar`], JimJam: [`jim`, `jam`] };
model.taggedTypes = { Value: `UUID`, PrintJobId: `Int` };
model.relations = {
  kids: { type: `Kid`, relationType: `Children` },
  parent: { type: `Parent`, relationType: `OptionalParent` },
};
model.init = [
  { propName: `id`, hasDefault: true },
  { propName: `name`, hasDefault: false },
  { propName: `desc`, hasDefault: false },
  { propName: `fooBar`, hasDefault: false },
  { propName: `jimJam`, hasDefault: false },
  { propName: `value`, hasDefault: false },
  { propName: `email`, hasDefault: false },
  { propName: `price`, hasDefault: false },
  { propName: `parentId`, hasDefault: false },
  { propName: `optionalParentId`, hasDefault: false },
  { propName: `printJobId`, hasDefault: false },
  { propName: `splits`, hasDefault: false },
  { propName: `optionalSplits`, hasDefault: false },
];
model.props = [
  { name: `id`, type: `Id` },
  { name: `name`, type: `String` },
  { name: `desc`, type: `String?` },
  { name: `fooBar`, type: `FooBar` },
  { name: `jimJam`, type: `JimJam?` },
  { name: `value`, type: `Value` },
  { name: `email`, type: `EmailAddress` },
  { name: `price`, type: `Cents<Int>` },
  { name: `parentId`, type: `Parent.Id` },
  { name: `optionalParentId`, type: `Parent.Id?` },
  { name: `printJobId`, type: `PrintJobId?` },
  { name: `splits`, type: `NonEmpty<[Int]>` },
  { name: `optionalSplits`, type: `NonEmpty<[Int]>?` },
  { name: `createdAt`, type: `Date` },
  { name: `updatedAt`, type: `Date` },
  { name: `deletedAt`, type: `Date?` },
];

describe(`modelTypeToGraphQLInputType()`, () => {
  const cases: Array<[string, string]> = [
    [`String`, `String`],
    [`String?`, `String?`],
    [`Value`, `UUID`],
    [`Value?`, `UUID?`],
    [`EmailAddress`, `String`],
    [`EmailAddress?`, `String?`],
    [`Cents<Int>`, `Int`],
    [`Cents<Int>?`, `Int?`],
    [`Parent.Id`, `UUID`],
    [`Parent.Id?`, `UUID?`],
    [`PrintJobId`, `Int`],
    [`PrintJobId?`, `Int?`],
    [`Date`, `Date`],
    [`Date?`, `Date?`],
    [`FooBar`, `Thing.FooBar`],
    [`FooBar?`, `Thing.FooBar?`],
    [`JimJam`, `Thing.JimJam`],
    [`JimJam?`, `Thing.JimJam?`],
  ];

  test.each(cases)(`%s -> %s`, (modelType, gqlType) => {
    expect(modelTypeToGraphQLInputType(modelType, model, types)).toBe(gqlType);
  });
});

describe(`modelPropToInitArg()`, () => {
  const cases: Array<[string, string]> = [
    [`id`, `.init(rawValue: input.id ?? UUID())`],
    [`name`, `input.name`],
    [`desc`, `input.desc`],
    [`value`, `.init(rawValue: input.value)`],
    [`email`, `.init(rawValue: input.email)`],
    [`price`, `.init(rawValue: input.price)`],
    [`parentId`, `.init(rawValue: input.parentId)`],
    [`printJobId`, `input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil`],
    [`splits`, `try NonEmpty<[Int]>.fromArray(input.splits)`],
    [`optionalSplits`, `try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? [])`],
  ];

  test.each(cases)(`%s -> %s`, (prop, initArg) => {
    expect(modelPropToInitArg(prop, model, types, `create`)).toBe(initArg);
  });
});

describe(`schemaTypeFieldParts()`, () => {
  const expected = [
    [`id`, `at`, `\\.id.rawValue`],
    [`name`, `at`, `\\.name`],
    [`desc`, `at`, `\\.desc`],
    [`fooBar`, `at`, `\\.fooBar`],
    [`jimJam`, `at`, `\\.jimJam`],
    [`value`, `at`, `\\.value.rawValue`],
    [`email`, `at`, `\\.email.rawValue`],
    [`price`, `at`, `\\.price.rawValue`],
    [`parentId`, `at`, `\\.parentId.rawValue`],
    [`optionalParentId`, `at`, `\\.optionalParentId?.rawValue`],
    [`printJobId`, `at`, `\\.printJobId?.rawValue`],
    [`splits`, `at`, `\\.splits.rawValue`],
    [`optionalSplits`, `at`, `\\.optionalSplits?.rawValue`],
    [`createdAt`, `at`, `\\.createdAt`],
    [`updatedAt`, `at`, `\\.updatedAt`],
    [`kids`, `with`, `\\.kids`],
    [`parent`, `with`, `\\.parent`],
  ];

  expect(schemaTypeFieldParts(model, types)).toEqual(expected);
});

describe(`generateModelGraphQLTypes()`, () => {
  it(`generates graphql types`, () => {
    const expected = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import Graphiti
      import NonEmpty
      import Vapor

      extension AppSchema {
        static var ThingType: AppType<Thing> {
          Type(Thing.self) {
            Field("id", at: \\.id.rawValue)
            Field("name", at: \\.name)
            Field("desc", at: \\.desc)
            Field("fooBar", at: \\.fooBar)
            Field("jimJam", at: \\.jimJam)
            Field("value", at: \\.value.rawValue)
            Field("email", at: \\.email.rawValue)
            Field("price", at: \\.price.rawValue)
            Field("parentId", at: \\.parentId.rawValue)
            Field("optionalParentId", at: \\.optionalParentId?.rawValue)
            Field("printJobId", at: \\.printJobId?.rawValue)
            Field("splits", at: \\.splits.rawValue)
            Field("optionalSplits", at: \\.optionalSplits?.rawValue)
            Field("createdAt", at: \\.createdAt)
            Field("updatedAt", at: \\.updatedAt)
            Field("kids", with: \\.kids)
            Field("parent", with: \\.parent)
          }
        }

        struct CreateThingInput: Codable {
          let id: UUID?
          let name: String
          let desc: String?
          let fooBar: Thing.FooBar
          let jimJam: Thing.JimJam?
          let value: UUID
          let email: String
          let price: Int
          let parentId: UUID
          let optionalParentId: UUID?
          let printJobId: Int?
          let splits: [Int]
          let optionalSplits: [Int]?
        }

        struct UpdateThingInput: Codable {
          let id: UUID
          let name: String
          let desc: String?
          let fooBar: Thing.FooBar
          let jimJam: Thing.JimJam?
          let value: UUID
          let email: String
          let price: Int
          let parentId: UUID
          let optionalParentId: UUID?
          let printJobId: Int?
          let splits: [Int]
          let optionalSplits: [Int]?
        }

        struct CreateThingArgs: Codable {
          let input: AppSchema.CreateThingInput
        }

        struct UpdateThingArgs: Codable {
          let input: AppSchema.UpdateThingInput
        }

        struct CreateThingsArgs: Codable {
          let input: [AppSchema.CreateThingInput]
        }

        struct UpdateThingsArgs: Codable {
          let input: [AppSchema.UpdateThingInput]
        }

        static var CreateThingInputType: AppInput<AppSchema.CreateThingInput> {
          Input(AppSchema.CreateThingInput.self) {
            InputField("id", at: \\.id)
            InputField("name", at: \\.name)
            InputField("desc", at: \\.desc)
            InputField("fooBar", at: \\.fooBar)
            InputField("jimJam", at: \\.jimJam)
            InputField("value", at: \\.value)
            InputField("email", at: \\.email)
            InputField("price", at: \\.price)
            InputField("parentId", at: \\.parentId)
            InputField("optionalParentId", at: \\.optionalParentId)
            InputField("printJobId", at: \\.printJobId)
            InputField("splits", at: \\.splits)
            InputField("optionalSplits", at: \\.optionalSplits)
          }
        }

        static var UpdateThingInputType: AppInput<AppSchema.UpdateThingInput> {
          Input(AppSchema.UpdateThingInput.self) {
            InputField("id", at: \\.id)
            InputField("name", at: \\.name)
            InputField("desc", at: \\.desc)
            InputField("fooBar", at: \\.fooBar)
            InputField("jimJam", at: \\.jimJam)
            InputField("value", at: \\.value)
            InputField("email", at: \\.email)
            InputField("price", at: \\.price)
            InputField("parentId", at: \\.parentId)
            InputField("optionalParentId", at: \\.optionalParentId)
            InputField("printJobId", at: \\.printJobId)
            InputField("splits", at: \\.splits)
            InputField("optionalSplits", at: \\.optionalSplits)
          }
        }

        static var getThing: AppField<Thing, IdentifyEntityArgs> {
          Field("getThing", at: Resolver.getThing) {
            Argument("id", at: \\.id)
          }
        }

        static var getThings: AppField<[Thing], NoArgs> {
          Field("getThings", at: Resolver.getThings)
        }

        static var createThing: AppField<Thing, AppSchema.CreateThingArgs> {
          Field("createThing", at: Resolver.createThing) {
            Argument("input", at: \\.input)
          }
        }

        static var createThings: AppField<[Thing], AppSchema.CreateThingsArgs> {
          Field("createThings", at: Resolver.createThings) {
            Argument("input", at: \\.input)
          }
        }

        static var updateThing: AppField<Thing, AppSchema.UpdateThingArgs> {
          Field("updateThing", at: Resolver.updateThing) {
            Argument("input", at: \\.input)
          }
        }

        static var updateThings: AppField<[Thing], AppSchema.UpdateThingsArgs> {
          Field("updateThings", at: Resolver.updateThings) {
            Argument("input", at: \\.input)
          }
        }

        static var deleteThing: AppField<Thing, IdentifyEntityArgs> {
          Field("deleteThing", at: Resolver.deleteThing) {
            Argument("id", at: \\.id)
          }
        }
      }

      extension Thing {
        convenience init(_ input: AppSchema.CreateThingInput) throws {
          self.init(
            id: .init(rawValue: input.id ?? UUID()),
            name: input.name,
            desc: input.desc,
            fooBar: input.fooBar,
            jimJam: input.jimJam,
            value: .init(rawValue: input.value),
            email: .init(rawValue: input.email),
            price: .init(rawValue: input.price),
            parentId: .init(rawValue: input.parentId),
            optionalParentId: input.optionalParentId != nil ? .init(rawValue: input.optionalParentId!) : nil,
            printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
            splits: try NonEmpty<[Int]>.fromArray(input.splits),
            optionalSplits: try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? [])
          )
        }

        convenience init(_ input: AppSchema.UpdateThingInput) throws {
          self.init(
            id: .init(rawValue: input.id),
            name: input.name,
            desc: input.desc,
            fooBar: input.fooBar,
            jimJam: input.jimJam,
            value: .init(rawValue: input.value),
            email: .init(rawValue: input.email),
            price: .init(rawValue: input.price),
            parentId: .init(rawValue: input.parentId),
            optionalParentId: input.optionalParentId != nil ? .init(rawValue: input.optionalParentId!) : nil,
            printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
            splits: try NonEmpty<[Int]>.fromArray(input.splits),
            optionalSplits: try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? [])
          )
        }

        func update(_ input: AppSchema.UpdateThingInput) throws {
          self.name = input.name
          self.desc = input.desc
          self.fooBar = input.fooBar
          self.jimJam = input.jimJam
          self.value = .init(rawValue: input.value)
          self.email = .init(rawValue: input.email)
          self.price = .init(rawValue: input.price)
          self.parentId = .init(rawValue: input.parentId)
          self.optionalParentId = input.optionalParentId != nil ? .init(rawValue: input.optionalParentId!) : nil
          self.printJobId = input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil
          self.splits = try NonEmpty<[Int]>.fromArray(input.splits)
          self.optionalSplits = try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? [])
          self.updatedAt = Current.date()
        }
      }
    `).trim();

    const [filepath, generated] = generateModelGraphQLTypes(model, types);
    expect(filepath).toBe(`Sources/App/Models/Generated/Thing+GraphQL.swift`);
    expect(generated).toBe(expected + `\n`);
  });

  it(`removes throws if no non-empty`, () => {
    const model = Model.mock();
    model.init = [
      { propName: `id`, hasDefault: true },
      { propName: `name`, hasDefault: false },
    ];
    model.props = [
      { name: `id`, type: `Id` },
      { name: `name`, type: `String` },
    ];

    const [, generated] = generateModelGraphQLTypes(model, types);
    expect(generated).not.toContain(` throws `);
  });
});
