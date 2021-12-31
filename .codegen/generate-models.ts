import path from 'path';
import fs from 'fs';
import { generateModelConformances } from './lib/models/model-conformances';
import { generateModelMocks } from './lib/models/model-mocks';
import { generateModelGraphQLTypes } from './lib/models/graphql';
import { scriptData } from './lib/script-helpers';

const { models, appRoot, isDryRun, types } = scriptData();

for (const model of models) {
  const [conformancePath, conformanceCode] = generateModelConformances(model, types);
  if (isDryRun) {
    printCode(`conformances`, conformancePath, conformanceCode);
  } else {
    fs.writeFileSync(`${appRoot}/${conformancePath}`, conformanceCode);
  }

  const [mocksPath, mocksCode] = generateModelMocks(model, types);
  if (isDryRun) {
    printCode(`mocks`, mocksPath, mocksCode);
  } else {
    const testDir = path.dirname(`${appRoot}/${mocksPath}`);
    if (!fs.existsSync(testDir)) {
      fs.mkdirSync(testDir);
    }
    fs.writeFileSync(`${appRoot}/${mocksPath}`, mocksCode);
  }

  const [graphqlPath, graphqlCode] = generateModelGraphQLTypes(model, types);
  if (isDryRun) {
    printCode(`graphql`, graphqlPath, graphqlCode);
  } else {
    fs.writeFileSync(`${appRoot}/${graphqlPath}`, graphqlCode);
  }
}

function printCode(identifier: string, path: string, code: string): void {
  console.log(`Write generated ${identifier} to filepath: "${path}":`);
  console.log(`\n`);
  console.log(code);
  console.log(`\n`);
  console.log(`\n`);
}
