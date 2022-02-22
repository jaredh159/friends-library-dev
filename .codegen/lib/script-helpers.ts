import { GlobalTypes } from './types';
import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractGlobalTypes, extractModels } from './models/model-attrs';
import Model from './models/Model';

type ScriptData = {
  isDryRun: boolean;
  appRoot: string;
  appDir: string;
  files: Array<{ path: string; source: string }>;
  types: GlobalTypes;
  models: Model[];
};

export function requireModel(
  data: ReturnType<typeof scriptData>,
): ScriptData & { model: Model } {
  const { model, ...rest } = data;
  if (!model) {
    console.log(`No model selected. --model Thing`);
    process.exit(1);
  }
  return {
    ...rest,
    model,
  };
}

export function scriptData(): ScriptData & { model?: Model } {
  const isDryRun = !process.argv.includes(`--perform`) && !process.argv.includes(`-p`);
  const appRoot = path.resolve(__dirname, `..`, `..`);
  const appDir = path.resolve(appRoot, `Sources`, `App`);

  const files = glob(`${appDir}/**/*.swift`).map((abspath) => ({
    path: abspath.replace(`${appRoot}/`, ``),
    source: fs.readFileSync(abspath, `utf-8`),
  }));

  const types = extractGlobalTypes(files.map((f) => f.source));
  const models = extractModels(files);

  let modelArgIndex = process.argv.indexOf(`--model`);
  if (modelArgIndex === -1) {
    modelArgIndex = process.argv.indexOf(`-m`);
  }
  let modelName = process.argv[modelArgIndex + 1] ?? ``;
  const model = models.find((m) => m.name === modelName);

  return {
    isDryRun,
    appRoot,
    appDir,
    files,
    types,
    models,
    model,
  };
}

export function printCode(identifier: string, path: string, code: string): void {
  console.log(`Write generated ${identifier} to filepath: "${path}":\n`);
  console.log(code + `\n\n`);
}
