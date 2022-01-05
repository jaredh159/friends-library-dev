import fs from 'fs';
import { scriptData, printCode, requireModel } from './lib/script-helpers';

function main() {
  const { appRoot, isDryRun, model } = requireModel(scriptData());

  let extensions: string[] = [];
  let children = Object.entries(model.relations).filter(
    ([, { relationType }]) => relationType === `Children`,
  );

  let parents = Object.entries(model.relations).filter(
    ([, { relationType }]) => relationType === `Parent`,
  );

  let optionalChilds = Object.entries(model.relations).filter(
    ([, { relationType }]) => relationType === `OptionalChild`,
  );

  let optionalParents = Object.entries(model.relations).filter(
    ([, { relationType }]) => relationType === `OptionalParent`,
  );

  for (const [name, { type }] of children) {
    let extension = CHILDREN_PATTERN.replace(/ThingChild/g, type)
      .replace(/thing\.children/g, `${model.camelCaseName}.${name}`)
      .replace(/thing/g, model.camelCaseName)
      .replace(/Thing/g, model.name)
      .replace(/thingChildren/g, name);
    extensions.push(extension);
  }

  for (const [name, { type }] of optionalChilds) {
    let extension = OPTIONAL_CHILD_PATTERN.replace(/ThingChild/g, type)
      .replace(/thing\.child/g, `${model.camelCaseName}.${name}`)
      .replace(/thing/g, model.camelCaseName)
      .replace(/Thing/g, model.name)
      .replace(/\bchild\b/g, name);
    extensions.push(extension);
  }

  for (const [name, { type }] of parents) {
    let extension = PARENT_PATTERN.replace(/ThingParent/g, type)
      .replace(/thing\.parent/g, `${model.camelCaseName}.${name}`)
      .replace(/Thing/g, model.name)
      .replace(/thingParentId/g, `${name}Id`)
      .replace(/parent/g, name)
      .replace(/thing/g, model.camelCaseName);
    extensions.push(extension);
  }

  for (const [name, { type }] of optionalParents) {
    let extension = OPTIONAL_PARENT_PATTERN.replace(/ThingParent/g, type)
      .replace(/thing\.parent/g, `${model.camelCaseName}.${name}`)
      .replace(/Thing/g, model.name)
      .replace(/thingParentId/g, `${name}Id`)
      .replace(/parent/g, name)
      .replace(/thing/g, model.camelCaseName);
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
      at: resolveChildren { (thing) async throws -> [ThingChild] in
        switch thing.children {
          case .notLoaded:
            throw Abort(.notImplemented, reason: "Thing -> Children<[ThingChild]> not implemented")
          case let .loaded(thingChildren):
            return thingChildren
        }
      },
      as: [TypeRef<ThingChild>].self)
  }
}
`;

const OPTIONAL_CHILD_PATTERN = /* swift */ `
extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Thing {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalChild<ThingChild>
  ) where FieldType == TypeRef<ThingChild>? {
    self.init(
      name.description,
      at: resolveOptionalChild { (thing) async throws -> ThingChild? in
        switch thing.child {
          case .notLoaded:
            throw Abort(.notImplemented, reason: "Thing -> OptionalChild<ThingChild> not implemented")
          case let .loaded(child):
            return child
        }
      },
      as: TypeRef<ThingChild>?.self)
  }
}
`;

const OPTIONAL_PARENT_PATTERN = /* swift */ `
extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Thing {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalParent<ThingParent>
  ) where FieldType == TypeRef<ThingParent>? {
    self.init(
      name.description,
      at: resolveOptionalParent { (thing) async throws -> ThingParent? in
        switch thing.parent {
          case .notLoaded:
            // guard let thingParentId = thing.thingParentId else { return nil }
            throw Abort(.notImplemented, reason: "Thing -> OptionalParent<ThingParent> not implemented")
          case let .loaded(parent):
            return parent
        }
      },
      as: TypeReference<ThingParent>?.self)
  }
}
`;

const PARENT_PATTERN = /* swift */ `
extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Thing {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<ThingParent>
  ) where FieldType == TypeRef<ThingParent> {
    self.init(
      name.description,
      at: resolveParent { (thing) async throws -> ThingParent in
        switch thing.parent {
          case .notLoaded:
            throw Abort(.notImplemented, reason: "Thing -> Parent<ThingParent> not implemented")
          case let .loaded(parent):
            return parent
        }
      },
      as: TypeReference<ThingParent>.self)
  }
}
`;

main();
