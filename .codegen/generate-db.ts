import fs from 'fs';
import { isNotNull } from 'x-ts-utils';
import { scriptData } from './lib/script-helpers';

function main() {
  const { dbClientProps, repositories, appRoot, models } = scriptData();
  let code = PATTERN.replace(
    `/* NOT_IMPLEMENTED_INIT_ARGS */`,
    dbClientProps
      .map(([prop, numArgs]) => {
        const args = closureArgs(numArgs);
        const reason = `db.${prop}`;
        return `${prop}: {${args}\n      throw Abort(.notImplemented, reason: "${reason}")\n    }`;
      })
      .join(`,\n    `),
  );

  code = code.replace(
    `/* LIVE_REPOS_CREATE */`,
    models
      .map((m) => `let ${m.camelCaseName}s = Repository<${m.name}>(db: db)`)
      .join(`\n    `),
  );

  code = code.replace(
    /\/\* REPOS_ASSIGNS \*\//g,
    models.map((m) => `${m.camelCaseName}s.assign(client: &client)`).join(`\n    `),
  );

  code = code.replace(
    /\/\* REPOS_DELEGATES \*\//g,
    dbClientProps
      .map(([fn]) => {
        const match = fn.match(/^(create|update|deleteAll|delete|get)(.*?)(s)?$/);
        if (!match) {
          return null;
        }
        const [, verb = ``, modelName = ``, s] = match;
        const model = models.find((m) => m.name === modelName);
        if (!model) {
          return null;
        }
        const isPlural = s === `s`;
        switch (`${verb}--${isPlural}`) {
          case `get--true`:
            return `client.${fn} = { try await ${model.camelCaseName}s.findAll(where: $0) }`;
          case `get--false`:
            return `client.${fn} = { try await ${model.camelCaseName}s.find($0) }`;
          case `create--true`:
          case `create--false`:
            return `client.${fn} = { try await ${model.camelCaseName}s.create($0) }`;
          case `update--true`:
          case `update--false`:
            return `client.${fn} = { try await ${model.camelCaseName}s.update($0) }`;
          case `delete--false`:
            return `client.${fn} = { try await ${model.camelCaseName}s.delete($0) }`;
          case `deleteAll--true`:
            return `client.${fn} = { try await ${model.camelCaseName}s.deleteAll() }`;
          default:
            throw new Error(`Unexpected fn ${fn}`);
        }
      })
      .filter(isNotNull)
      .join(`\n    `),
  );

  code = code.replace(
    `/* MOCK_REPOS_CREATE */`,
    models
      .map(
        (m) =>
          `let ${m.camelCaseName}s = MockRepository<${m.name}>(db: db, models: \\.${m.camelCaseName}s)`,
      )
      .join(`\n    `),
  );

  const generatedPath = `${appRoot}/Sources/App/Database/DatabaseClient+Generated.swift`;
  fs.writeFileSync(generatedPath, code + `\n`);
}

const PATTERN = /* swift */ `
// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    let entitiesRepo = EntityRepository(db: db)
    /* LIVE_REPOS_CREATE */
    /* REPOS_DELEGATES */
    /* REPOS_ASSIGNS */
    entitiesRepo.assign(client: &client)
    return client
  }

  static var mock: DatabaseClient {
    let db = MockDb()
    var client: DatabaseClient = .notImplemented
    let entitiesRepo = MockEntityRepository(db: db)
    /* MOCK_REPOS_CREATE */
    /* REPOS_DELEGATES */
    /* REPOS_ASSIGNS */
    entitiesRepo.assign(client: &client)
    return client
  }

  static let notImplemented = DatabaseClient(
    /* NOT_IMPLEMENTED_INIT_ARGS */
  )
}
`.trim();

function closureArgs(numArgs: number): string {
  switch (numArgs) {
    case 0:
      return ``;
    case 1:
      return ` _ in`;
    case 2:
      return ` _, _ in`;
    case 3:
      return ` _, _, _ in`;
    case 4:
      return ` _, _, _, _ in`;
    default:
      throw new Error(`num closure args=${numArgs} not supported`);
  }
}

main();
