import fs from 'fs';
import { generateResolverScaffold } from './lib/models/scaffold-resolvers';
import { requireModel, scriptData, printCode } from './lib/script-helpers';

const { model, isDryRun } = requireModel(scriptData());
const [path, code] = generateResolverScaffold(model);

if (isDryRun) {
  printCode(`resolver`, path, code);
} else {
  if (fs.existsSync(path)) {
    const contents = fs.readFileSync(path, `utf-8`);
    if (!contents.includes(`below auto-generated`)) {
      fs.writeFileSync(path, `${contents}\n\n${code}`);
    }
  } else {
    fs.writeFileSync(path, `import Vapor\n\n${code}`);
  }
}
