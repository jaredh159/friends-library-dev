import { GlobalTypes, Model } from './types';
import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractGlobalTypes, extractModels } from './models/model-attrs';

export function scriptData(): {
  isDryRun: boolean;
  appRoot: string;
  appDir: string;
  files: Array<{ path: string; source: string }>;
  types: GlobalTypes;
  models: Model[];
} {
  const isDryRun = process.argv.includes(`--dry-run`);
  const appRoot = path.resolve(__dirname, `..`, `..`);
  const appDir = path.resolve(appRoot, `Sources`, `App`);
  const files = glob(`${appDir}/**/*.swift`).map((abspath) => ({
    path: abspath.replace(`${appRoot}/`, ``),
    source: fs.readFileSync(abspath, `utf-8`),
  }));

  const types = extractGlobalTypes(files.map((f) => f.source));
  const models = extractModels(files);
  return {
    isDryRun,
    appRoot,
    appDir,
    files,
    types,
    models,
  };
}
