import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractGlobalTypes, extractModels } from './model-attrs';
import { generateModelConformances } from './conformances';

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
  const [filepath, code] = generateModelConformances(model, globalTypes);
  if (isDryRun) {
    console.log(`Write to filepath: "${filepath}":`);
    console.log(`\n`);
    console.log(code);
    console.log(`\n`);
    console.log(`\n`);
  } else {
    fs.writeFileSync(`${appRoot}/${filepath}`, code);
  }
}
