import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { insertData } from '../model-db-data';
import { GlobalTypes } from '../../types';

describe(`insertData()`, () => {
  it(`can handle all types of columns`, () => {
    const globalTypes: GlobalTypes = {
      dbEnums: { JimJam: [`jim`, `jam`] },
      taggedTypes: { GitCommitSha: `String` },
    };

    const model = {
      name: `Thing`,
      filepath: `/`,
      taggedTypes: { FooId: `Int`, PaymentId: `String` },
      dbEnums: {},
      props: [
        { name: `id`, type: `Id` },
        { name: `parentId`, type: `OtherModel.Id` },
        { name: `optionalParentId`, type: `RandoModel.Id?` },
        { name: `published`, type: `Date?` },
        { name: `lols`, type: `NonEmpty<[Int]>` },
        { name: `optionalLols`, type: `NonEmpty<[Int]>?` },
        { name: `honestInt`, type: `Int` },
        { name: `optionalInt`, type: `Int?` },
        { name: `honestString`, type: `String` },
        { name: `optionalString`, type: `String?` },
        { name: `fooId`, type: `FooId` },
        { name: `optionalFooId`, type: `FooId?` },
        { name: `paymentId`, type: `PaymentId` },
        { name: `myBool`, type: `Bool` },
        { name: `jimJam`, type: `JimJam` },
        { name: `someRandoEnum`, type: `Suit` },
        { name: `sha`, type: `GitCommitSha` },
        { name: `createdAt`, type: `Date` },
        { name: `updatedAt`, type: `Date` },
        { name: `deletedAt`, type: `Date?` },
      ],
      init: [],
    };

    const expected = stripIndent(/* swift */ `
      extension Thing {
        var insertValues: [String: Postgres.Data] {
          [
            Self[.id]: .id(self),
            Self[.parentId]: .uuid(parentId),
            Self[.optionalParentId]: .uuid(optionalParentId),
            Self[.published]: .date(published),
            Self[.lols]: .intArray(lols.array),
            Self[.optionalLols]: .intArray(optionalLols?.array),
            Self[.honestInt]: .int(honestInt),
            Self[.optionalInt]: .int(optionalInt),
            Self[.honestString]: .string(honestString),
            Self[.optionalString]: .string(optionalString),
            Self[.fooId]: .int(fooId.rawValue),
            Self[.optionalFooId]: .int(optionalFooId?.rawValue),
            Self[.paymentId]: .string(paymentId.rawValue),
            Self[.myBool]: .bool(myBool),
            Self[.jimJam]: .enum(jimJam),
            Self[.someRandoEnum]: .enum(someRandoEnum),
            Self[.sha]: .string(sha.rawValue),
            Self[.createdAt]: .currentTimestamp,
            Self[.updatedAt]: .currentTimestamp,
          ]
        }
      }
    `).trim();

    expect(insertData(model, globalTypes)).toBe(expected);
  });
});
