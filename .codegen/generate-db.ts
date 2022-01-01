import fs from 'fs';
import { scriptData } from './lib/script-helpers';

function main() {
  const { dbClientProps, repositories, appRoot } = scriptData();
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
    `/* LIVE_DB_ASSIGNS */`,
    repositories.map((repo) => `${repo}(db: db).assign(client: &client)`).join(`\n    `),
  );

  code = code.replace(
    `/* MOCK_DB_ASSIGNS */`,
    repositories
      .map((repo) => `Mock${repo}(db: mockDb).assign(client: &client)`)
      .join(`\n    `),
  );

  const generatedPath = `${appRoot}/Sources/App/Database/DatabaseClient+Generated.swift`;
  fs.writeFileSync(generatedPath, code + `\n`);
}

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

const PATTERN = /* swift */ `
// auto-generated, do not edit
import FluentSQL
import Vapor

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    /* LIVE_DB_ASSIGNS */
    return client
  }

  static var mock: DatabaseClient {
    let mockDb = MockDb()
    var client: DatabaseClient = .notImplemented
    /* MOCK_DB_ASSIGNS */
    return client
  }

  static let notImplemented = DatabaseClient(
    /* NOT_IMPLEMENTED_INIT_ARGS */
  )
}
`.trim();

main();
