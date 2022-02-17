import stripIndent from 'strip-indent';
import { GlobalTypes } from '../types';
import Model, { Prop } from './Model';

export function insertData(model: Model, types: GlobalTypes): string {
  let code = stripIndent(/* swift */ `
    extension __MODEL_NAME__ {
      var insertValues: [ColumnName: Postgres.Data] {
        [
          // VALUES_HERE
        ]
      }
    } 
  `).trim();

  const values = model.props
    .filter((p) => p.name != `deletedAt`)
    .map((prop) => [prop.name, toPostgresData(prop, model, types, `forInsert`)]);

  return code
    .replace(`__MODEL_NAME__`, model.name)
    .replace(
      `// VALUES_HERE`,
      values.map(([ident, value]) => `.${ident}: ${value},`).join(`\n      `),
    );
}

export function toPostgresData(
  prop: Prop,
  model: Model,
  types: GlobalTypes,
  purpose: 'forInsert' | 'forInspect',
): string {
  const { name: ident, type } = prop;
  if (
    type === `Date` &&
    [`createdAt`, `updatedAt`].includes(ident) &&
    purpose === `forInsert`
  ) {
    return `.currentTimestamp`;
  }

  if (type.match(/.+\.Id\??$/)) {
    return `.uuid(${ident})`;
  }

  switch (type) {
    case `Id`:
      return `.id(self)`;
    case `NonEmpty<[Int]>`:
      return `.intArray(${ident}.array)`;
    case `NonEmpty<[Int]>?`:
      return `.intArray(${ident}?.array)`;
    case `Seconds<Double>`:
      return `.double(${ident}.rawValue)`;
    case `Cents<Int>`:
      return `.int(${ident}.rawValue)`;
    case `Date`:
    case `Date?`:
      return `.date(${ident})`;
    case `Int64`:
    case `Int64?`:
      return `.int64(${ident})`;
    case `Int`:
    case `Int?`:
      return `.int(${ident})`;
    case `Bool`:
    case `Bool?`:
      return `.bool(${ident})`;
    case `String`:
    case `String?`:
      return `.string(${ident})`;
    default:
      const chain = type.endsWith(`?`) ? `?.` : `.`;
      const honestType = type.replace(/\?$/, ``);
      const taggedType = model.taggedTypes[honestType] || types.taggedTypes[honestType];
      if (taggedType) {
        switch (taggedType) {
          case `Int`:
            return `.int(${ident}${chain}rawValue)`;
          case `Int64`:
            return `.int64(${ident}${chain}rawValue)`;
          case `UUID`:
            return `.uuid(${ident})`;
          case `String`:
            return `.string(${ident}${chain}rawValue)`;
          default:
            throw new Error(`Tagged subtype ${taggedType} not implemented`);
        }
      }

      return `.enum(${ident})`;
  }
}
