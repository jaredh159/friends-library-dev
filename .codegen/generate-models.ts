import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractGlobalTypes, extractModels } from './lib/models/model-attrs';
import { generateModelConformances } from './lib/models/model-conformances';
import { generateModelMocks } from './lib/models/model-mocks';

const isDryRun = process.argv.includes(`--dry-run`);
const appRoot = path.resolve(__dirname, `..`);
const appDir = path.resolve(appRoot, `Sources`, `App`);

const files = glob(`${appDir}/**/*.swift`).map((abspath) => ({
  path: abspath.replace(`${appRoot}/`, ``),
  source: fs.readFileSync(abspath, `utf-8`),
}));

const globalTypes = extractGlobalTypes(files.map((f) => f.source));
const models = extractModels(files);

for (const model of models) {
  const [conformancePath, conformanceCode] = generateModelConformances(
    model,
    globalTypes,
  );
  if (isDryRun) {
    console.log(`Write to filepath: "${conformancePath}":`);
    console.log(`\n`);
    console.log(conformanceCode);
    console.log(`\n`);
    console.log(`\n`);
  } else {
    fs.writeFileSync(`${appRoot}/${conformancePath}`, conformanceCode);
  }

  const [mocksPath, mocksCode] = generateModelMocks(model, globalTypes);
  if (isDryRun) {
    console.log(`Write to filepath: "${mocksPath}":`);
    console.log(`\n`);
    console.log(mocksCode);
    console.log(`\n`);
    console.log(`\n`);
  } else {
    fs.writeFileSync(`${appRoot}/${mocksPath}`, mocksCode);
  }
}
