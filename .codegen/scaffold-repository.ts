import fs from 'fs';
import { scriptData, printCode, requireModel } from './lib/script-helpers';

function main() {
  const { appRoot, isDryRun, model } = requireModel(scriptData());

  let code = REPO_PATTERN.replace(/Thing/g, model.name).replace(
    /\.things/g,
    `\.${model.camelCaseName}s`,
  );

  const generatedPath = `${appRoot}/${model.dir}/${model.name}+Repository.swift`;
  if (fs.existsSync(generatedPath)) {
    code = fs.readFileSync(generatedPath, `utf-8`) + `\n\n` + code;
  }

  if (isDryRun) {
    printCode(`repository`, generatedPath, code);
  } else {
    fs.writeFileSync(generatedPath, code);
  }
}

const REPO_PATTERN = /* swift */ `
import FluentSQL
import Vapor

struct ThingRepository: LiveRepository {
  typealias Model = Thing
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createThing = { try await create($0) }
    client.createThings = { try await create($0) }
    client.getThing = { try await find($0) }
    client.getThings = { try await select() }
    client.updateThing = { try await update($0) }
    client.updateThings = { try await update($0) }
    client.deleteThing = { try await delete($0) }
    client.deleteAllThings = { try await deleteAll() }
  }
}

struct MockThingRepository: MockRepository {
  typealias Model = Thing
  var db: MockDb
  var models: ModelsPath { \\.things }

  func assign(client: inout DatabaseClient) {
    client.createThing = { try await create($0) }
    client.createThings = { try await create($0) }
    client.getThing = { try await find($0) }
    client.getThings = { try await select() }
    client.updateThing = { try await update($0) }
    client.updateThings = { try await update($0) }
    client.deleteThing = { try await delete($0) }
    client.deleteAllThings = { try await deleteAll() }
  }
}
`;

main();
