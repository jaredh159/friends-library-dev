import path from 'path';
import fs from 'fs';
import { sync as glob } from 'glob';
import { extractGlobalTypes, extractModels } from './lib/models/model-attrs';
import { generateResolverScaffold } from './lib/models/scaffold-resolvers';

// @TODO duplication
const isDryRun = process.argv.includes(`--dry-run`);
const appRoot = path.resolve(__dirname, `..`);
const appDir = path.resolve(appRoot, `Sources`, `App`);

const files = glob(`${appDir}/**/*.swift`).map((abspath) => ({
  path: abspath.replace(`${appRoot}/`, ``),
  source: fs.readFileSync(abspath, `utf-8`),
}));

const globalTypes = extractGlobalTypes(files.map((f) => f.source));
const models = extractModels(files);

// @TODO, selective
for (const model of models) {
  const [path, code] = generateResolverScaffold(model.name);

  if (fs.existsSync(path)) {
    const contents = fs.readFileSync(path, `utf-8`);
    if (!contents.includes(`below auto-generated`)) {
      fs.writeFileSync(path, `${contents}\n\n${code}`);
    }
  } else {
    fs.writeFileSync(path, `import Vapor\n\n${code}`);
  }
}
