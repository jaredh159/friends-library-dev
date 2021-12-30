import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractGlobalTypes, extractModels } from './lib/models/model-attrs';

const isDryRun = process.argv.includes(`--dry-run`);
const appRoot = path.resolve(__dirname, `..`);
const appDir = path.resolve(appRoot, `Sources`, `App`);

const files = glob(`${appDir}/**/*.swift`).map((abspath) => ({
  path: abspath.replace(`${appRoot}/`, ``),
  source: fs.readFileSync(abspath, `utf-8`),
}));

const globalTypes = extractGlobalTypes(files.map((f) => f.source));
const models = extractModels(files);
