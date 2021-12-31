import fs from 'fs';
import { scriptData, printCode } from './lib/script-helpers';

function main() {
  const { appRoot, isDryRun, model } = scriptData();

  if (!model) {
    console.log(`No model selected. --model Thing`);
    process.exit(1);
  }

  let children = Object.entries(model.relations).filter(
    ([, { relationType }]) => relationType === `Children`,
  );

  let extensions: string[] = [];
  for (const [name, { type }] of children) {
    let extension = CHILDREN_PATTERN.replace(/ThingChild/g, type)
      .replace(/thing\.children/g, `${model.camelCaseName}.${name}`)
      .replace(/thing/g, model.camelCaseName)
      .replace(/Thing/g, model.name)
      .replace(/thingChildren/g, name);
    extensions.push(extension);
  }

  let code = extensions.join(`\n\n`) + `\n`;
  const generatedPath = `${appRoot}/${model.dir}/${model.name}+Graphiti.swift`;
  if (fs.existsSync(generatedPath)) {
    code = fs.readFileSync(generatedPath, `utf-8`) + `\n\n` + code;
  } else {
    code = `import Fluent\nimport Graphiti\nimport Vapor\n\n${code}`;
  }

  if (isDryRun) {
    printCode(`graphiti`, generatedPath, code);
  } else {
    fs.writeFileSync(generatedPath, code);
  }
}

const CHILDREN_PATTERN = /* swift */ `
extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Thing {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<ThingChild>
  ) where FieldType == [TypeRef<ThingChild>] {
    self.init(
      name.description,
      at: resolveChildren { thing, eventLoop -> Future<[ThingChild]> in
        switch thing.children {
          case .notLoaded:
            return future(of: [ThingChild].self, on: eventLoop) {
              fatalError("not implemented")
            }
          case let .loaded(thingChildren):
            return eventLoop.makeSucceededFuture(thingChildren)
        }
      },
      as: [TypeRef<ThingChild>].self)
  }
}
`;

main();
