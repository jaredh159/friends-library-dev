import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractModels } from './model-attrs';
import { generateModelConformances } from './conformances';

const isDryRun = process.argv.includes(`--dry-run`);
const appRoot = path.resolve(__dirname, `..`);
const modelDir = path.resolve(appRoot, `Sources`, `App`, `Models`);

const files = glob(`${modelDir}/**/*.swift`)
  .filter((p) => p.includes(`/Models/`))
  .map((abspath) => ({
    path: abspath.replace(`${appRoot}/`, ``),
    source: fs.readFileSync(abspath, `utf-8`),
  }));

const models = extractModels(files);
for (const model of models) {
  const [filepath, code] = generateModelConformances(model);
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
