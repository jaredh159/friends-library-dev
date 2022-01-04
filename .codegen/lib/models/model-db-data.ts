import { isNotNull } from 'x-ts-utils';
import stripIndent from 'strip-indent';
import { GlobalTypes } from '../types';
import Model from './Model';

export function insertData(model: Model, globalTypes: GlobalTypes): string {
  let code = stripIndent(/* swift */ `
    extension __MODEL_NAME__ {
      var insertValues: [String: Postgres.Data] {
        [
          // VALUES_HERE
        ]
      }
    } 
  `).trim();

  const values: Array<[name: string, value: string] | null> = model.props.map((prop) => {
    const { name: ident, type } = prop;
    if (ident === `deletedAt`) {
      return null;
    }

    if (type === `Date` && [`createdAt`, `updatedAt`].includes(ident)) {
      return [ident, `.currentTimestamp`];
    }

    if (type.match(/.+\.Id\??$/)) {
      return [ident, `.uuid(${ident})`];
    }

    switch (type) {
      case `Id`:
        return [ident, `.id(self)`];
      case `NonEmpty<[Int]>`:
        return [ident, `.intArray(${ident}.array)`];
      case `NonEmpty<[Int]>?`:
        return [ident, `.intArray(${ident}?.array)`];
      case `Seconds<Double>`:
        return [ident, `.double(${ident}.rawValue)`];
      case `Cents<Int>`:
        return [ident, `.int(${ident}.rawValue)`];
      case `Date`:
      case `Date?`:
        return [ident, `.date(${ident})`];
      case `Int64`:
      case `Int64?`:
        return [ident, `.int64(${ident})`];
      case `Int`:
      case `Int?`:
        return [ident, `.int(${ident})`];
      case `Bool`:
      case `Bool?`:
        return [ident, `.bool(${ident})`];
      case `String`:
      case `String?`:
        return [ident, `.string(${ident})`];
      default:
        const chain = type.endsWith(`?`) ? `?.` : `.`;
        const honestType = type.replace(/\?$/, ``);
        const taggedType =
          model.taggedTypes[honestType] || globalTypes.taggedTypes[honestType];
        if (taggedType) {
          switch (taggedType) {
            case `Int`:
              return [ident, `.int(${ident}${chain}rawValue)`];
            case `Int64`:
              return [ident, `.int64(${ident}${chain}rawValue)`];
            case `UUID`:
              return [ident, `.uuid(${ident})`];
            case `String`:
              return [ident, `.string(${ident}${chain}rawValue)`];
            default:
              throw new Error(`Tagged subtype ${taggedType} not implemented`);
          }
        }

        return [ident, `.enum(${ident})`];
    }
  });

  return code.replace(`__MODEL_NAME__`, model.name).replace(
    `// VALUES_HERE`,
    values
      .filter(isNotNull)
      .map(([ident, value]) => `Self[.${ident}]: ${value},`)
      .join(`\n      `),
  );
}
