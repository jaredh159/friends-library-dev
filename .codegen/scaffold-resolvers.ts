import fs from 'fs';
import { generateResolverScaffold } from './lib/models/scaffold-resolvers';
import { scriptData } from './lib/script-helpers';

const { models } = scriptData();

// @TODO, selective
for (const model of models) {
  const [path, code] = generateResolverScaffold(model);

  if (fs.existsSync(path)) {
    const contents = fs.readFileSync(path, `utf-8`);
    if (!contents.includes(`below auto-generated`)) {
      fs.writeFileSync(path, `${contents}\n\n${code}`);
    }
  } else {
    fs.writeFileSync(path, `import Vapor\n\n${code}`);
  }
}
