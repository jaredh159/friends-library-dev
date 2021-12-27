import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { insertData } from '../model-db-data';
import { GlobalTypes } from '../types';

describe(`insertData()`, () => {
  it(`can handle all types of columns`, () => {
    const globalTypes: GlobalTypes = {
      dbEnums: [`JimJam`],
      taggedTypes: { GitCommitSha: `String` },
    };

    const model = {
      name: `Thing`,
      filepath: `/`,
      taggedTypes: { FooId: `Int`, PaymentId: `String` },
      props: [
        { identifier: `id`, type: `Id` },
        { identifier: `parentId`, type: `OtherModel.Id` },
        { identifier: `optionalParentId`, type: `RandoModel.Id?` },
        { identifier: `published`, type: `Date?` },
        { identifier: `lols`, type: `NonEmpty<[Int]>` },
        { identifier: `optionalLols`, type: `NonEmpty<[Int]>?` },
        { identifier: `honestInt`, type: `Int` },
        { identifier: `optionalInt`, type: `Int?` },
        { identifier: `honestString`, type: `String` },
        { identifier: `optionalString`, type: `String?` },
        { identifier: `fooId`, type: `FooId` },
        { identifier: `optionalFooId`, type: `FooId?` },
        { identifier: `paymentId`, type: `PaymentId` },
        { identifier: `myBool`, type: `Bool` },
        { identifier: `jimJam`, type: `JimJam` },
        { identifier: `someRandoEnum`, type: `Suit` },
        { identifier: `sha`, type: `GitCommitSha` },
        { identifier: `createdAt`, type: `Date` },
        { identifier: `updatedAt`, type: `Date` },
        { identifier: `deletedAt`, type: `Date?` },
      ],
    };

    const expected = stripIndent(/* swift */ `
      extension Thing: DuetInsertable {
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
