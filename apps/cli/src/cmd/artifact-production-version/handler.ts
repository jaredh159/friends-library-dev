import { c, log } from 'x-chalk';
import api from '../../api-client';

interface Argv {
  sha: string;
}

export default async function handler({ sha }: Argv): Promise<void> {
  const result = await api.createArtifactProductionVersion({ version: sha });
  result.with({
    success: () => log(c`\nSuccessfully added version {green ${sha}}\n`),
    error: (err) => {
      if (err.detail?.includes(`duplicate key value violates unique constraint`)) {
        log(c`\n{red Error: version {yellow ${sha}} already exists, must be unique}\n`);
        process.exit(1);
      } else {
        log(c`\n{red Unexpected error, see detail below:}`);
        log(c`Error: {gray ${JSON.stringify(err)}}\n`);
        process.exit(1);
      }
    },
  });
}
