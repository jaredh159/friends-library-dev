import { isNotNull } from 'x-ts-utils';
import stripIndent from 'strip-indent';
import { Model, GlobalTypes } from './types';

export function insertData(model: Model, globalTypes: GlobalTypes): string {
  let code = stripIndent(/* swift */ `
    extension __MODEL_NAME__: DuetInsertable {
      var insertValues: [String: Postgres.Data] {
        [
          // VALUES_HERE
        ]
      }
    } 
  `).trim();

  const values: Array<[identifier: string, value: string] | null> = model.props.map(
    (prop) => {
      const { identifier: ident, type } = prop;
      if (ident === `deletedAt`) {
        return null;
      }

      if (type === `Date` && [`createdAt`, `updatedAt`].includes(ident)) {
        return [ident, `.currentTimestamp`];
      }

      switch (type) {
        case `Id`:
          return [ident, `.id(self)`];
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
              case `String`:
                return [ident, `.string(${ident}${chain}rawValue)`];
              default:
                throw new Error(`Tagged subtype ${taggedType} not implemented`);
            }
          }
          return [ident, `.enum(${ident})`];
      }
    },
  );

  return code.replace(`__MODEL_NAME__`, model.name).replace(
    `// VALUES_HERE`,
    values
      .filter(isNotNull)
      .map(([ident, value]) => `Self[.${ident}]: ${value},`)
      .join(`\n      `),
  );
}
