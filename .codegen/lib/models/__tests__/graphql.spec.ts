import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { GlobalTypes, Model } from '../../types';
import {
  generateModelGraphQLTypes,
  schemaTypeFieldPairs,
  modelTypeToGraphQLInputType,
  modelPropToInitArg,
} from '../graphql';

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

const model: Model = {
  name: `Thing`,
  filepath: `Sources/App/Models/Thing.swift`,
  dbEnums: { FooBar: [`foo`, `bar`], JimJam: [`jim`, `jam`] },
  taggedTypes: { Value: `UUID`, PrintJobId: `Int` },
  init: [
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
  ],
  props: [
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
  ],
};

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
    expect(modelPropToInitArg(prop, model, types)).toBe(initArg);
  });
});

describe(`schemaTypeFieldPairs()`, () => {
  const expected = [
    [`id`, `\\.id.rawValue`],
    [`name`, `\\.name`],
    [`desc`, `\\.desc`],
    [`fooBar`, `\\.fooBar`],
    [`jimJam`, `\\.jimJam`],
    [`value`, `\\.value.rawValue`],
    [`email`, `\\.email.rawValue`],
    [`price`, `\\.price.rawValue`],
    [`parentId`, `\\.parentId.rawValue`],
    [`optionalParentId`, `\\.optionalParentId?.rawValue`],
    [`printJobId`, `\\.printJobId?.rawValue`],
    [`splits`, `\\.splits.rawValue`],
    [`optionalSplits`, `\\.optionalSplits?.rawValue`],
    [`createdAt`, `\\.createdAt`],
    [`updatedAt`, `\\.updatedAt`],
  ];

  expect(schemaTypeFieldPairs(model, types)).toEqual(expected);
});

describe(`generateModelGraphQLTypes()`, () => {
  it(`generates graphql types`, () => {
    const expected = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import Graphiti
      import NonEmpty
      import Vapor

      extension Thing {
        enum GraphQL {
          enum Schema {
            enum Inputs {}
            enum Queries {}
            enum Mutations {}
          }
          enum Request {
            enum Inputs {}
            enum Args {}
          }
        }
      }

      extension Thing.GraphQL.Schema {
        static var type: AppType<Thing> {
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
          }
        }
      }

      extension Thing.GraphQL.Request.Inputs {
        struct Create: Codable {
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

        struct Update: Codable {
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
      }

      extension Thing.GraphQL.Request.Args {
        struct Create: Codable {
          let input: Thing.GraphQL.Request.Inputs.Create
        }

        struct Update: Codable {
          let input: Thing.GraphQL.Request.Inputs.Update
        }

        struct UpdateMany: Codable {
          let input: [Thing.GraphQL.Request.Inputs.Update]
        }

        struct CreateMany: Codable {
          let input: [Thing.GraphQL.Request.Inputs.Create]
        }
      }

      extension Thing.GraphQL.Schema.Inputs {
        static var create: AppInput<Thing.GraphQL.Request.Inputs.Create> {
          Input(Thing.GraphQL.Request.Inputs.Create.self) {
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

        static var update: AppInput<Thing.GraphQL.Request.Inputs.Update> {
          Input(Thing.GraphQL.Request.Inputs.Update.self) {
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
      }

      extension Thing.GraphQL.Schema.Queries {
        static var get: AppField<Thing, IdentifyEntityArgs> {
          Field("getThing", at: Resolver.getThing) {
            Argument("id", at: \\.id)
          }
        }

        static var list: AppField<[Thing], NoArgs> {
          Field("getThings", at: Resolver.getThings)
        }
      }

      extension Thing.GraphQL.Schema.Mutations {
        static var create: AppField<Thing, Thing.GraphQL.Request.Args.Create> {
          Field("createThing", at: Resolver.createThing) {
            Argument("input", at: \\.input)
          }
        }

        static var createMany: AppField<[Thing], Thing.GraphQL.Request.Args.CreateMany> {
          Field("createThing", at: Resolver.createThings) {
            Argument("input", at: \\.input)
          }
        }

        static var update: AppField<Thing, Thing.GraphQL.Request.Args.Update> {
          Field("createThing", at: Resolver.updateThing) {
            Argument("input", at: \\.input)
          }
        }

        static var updateMany: AppField<[Thing], Thing.GraphQL.Request.Args.UpdateMany> {
          Field("createThing", at: Resolver.updateThings) {
            Argument("input", at: \\.input)
          }
        }

        static var delete: AppField<Thing, IdentifyEntityArgs> {
          Field("deleteThing", at: Resolver.deleteThing) {
            Argument("id", at: \\.id)
          }
        }
      }

      extension Thing {
        convenience init(_ input: Thing.GraphQL.Request.Inputs.Create) throws {
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

        func update(_ input: Thing.GraphQL.Request.Inputs.Update) throws {
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
    expect(filepath).toBe(`Sources/App/Models/Things/Thing+GraphQL.swift`);
    expect(generated).toBe(expected + `\n`);
  });
});
