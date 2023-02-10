import { red, green } from 'x-chalk';
import exec from 'x-exec';
import chalk from 'chalk';
import type { CommandBuilder } from 'yargs';
import type { Argv } from '../type';
import { getRepos, getStatusGroups } from '../repos';
import { excludable, scopeable, relPath } from './helpers';

export async function handler({ exclude, scope, diff }: Argv): Promise<void> {
  let exitStatus = 0;
  const repos = await getRepos(exclude, scope);
  const { dirty } = await getStatusGroups(repos);
  if (dirty.length === 0) {
    green(`🛁  No uncommitted changes in any document repos.`);
    return;
  }

  red(`🚽  Uncommitted changes found in ${dirty.length} repos:`);
  dirty.forEach((repo) => {
    exitStatus++;
    // eslint-disable-next-line no-console
    console.log(`   ${chalk.grey(`↳`)} ${chalk.yellow(relPath(repo))}`);
    diff && exec.out(`git diff`, repo);
  });

  process.exit(exitStatus);
}

export const command = [`status`, `s`];

export const describe = `Reports the current status for all repos`;

export const builder: CommandBuilder = function (yargs) {
  return yargs
    .option(`exclude`, excludable.exclude)
    .option(`scopeable`, scopeable.scope)
    .option(`diff`, {
      default: false,
      type: `boolean`,
    });
};
