import { green } from 'x-chalk';
import type { Options } from 'yargs';
import type { Argv } from '../type';
import { getRepos, getStatusGroups } from '../repos';
import * as git from '../git';
import { excludable, scopeable } from './helpers';

export async function handler({ exclude, scope }: Argv): Promise<void> {
  const repos = await getRepos(exclude, scope);
  const { clean, dirty } = await getStatusGroups(repos);
  await Promise.all(clean.map(git.sync));
  green(`👍  ${clean.length} repos synced.`);
  process.exit(dirty.length);
}

export const command = `sync`;

export const describe = `like git pull --rebase`;

export const builder: { [key: string]: Options } = {
  ...excludable,
  ...scopeable,
};
