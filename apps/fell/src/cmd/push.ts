import path from 'path';
import { red, green } from 'x-chalk';
import type { CommandBuilder } from 'yargs';
import type { Argv as BaseArgv } from '../type';
import { getRepos } from '../repos';
import * as git from '../git';
import { openPullRequest } from '../github';
import { excludable, forceable } from './helpers';

type Argv = BaseArgv & {
  branch: string;
  force: boolean;
  openPr: boolean;
  prTitle?: string;
  prBody?: string;
  delay: number;
};

export async function handler({
  exclude,
  branch,
  force,
  openPr,
  prTitle,
  prBody,
  delay,
}: Argv): Promise<void> {
  let exitStatus = 0;
  let repos = await getRepos(exclude, branch);

  if (branch !== `master`) {
    const ahead = await Promise.all(repos.map((repo) => git.isAheadOfOriginMaster(repo)));
    repos = repos.filter((repo, index) => ahead[index]);
  }

  green(`${repos.length} repos will be pushed, starting in 10 seconds...\n`);
  await new Promise((resolve) => setTimeout(resolve, 10000));

  if (branch === `master` && force) {
    red(`Refusing to force push to master`);
    process.exit(1);
  }

  await Promise.all(repos.map((repo) => git.push(repo, branch, force)));
  if (branch === `master` || !openPr) {
    return;
  }

  // mass opening PRs quickly trips github's abuse limits, so we both
  // synchronously work through creating PRs, and delay between them
  for (const repo of repos) {
    const title = prTitle || (await git.getHeadCommitMessage(repo));
    const num = await openPullRequest(path.basename(repo), branch, title, prBody || ``);
    if (num) {
      green(`PR#${num} opened for repo: ${repo}`);
    } else {
      red(`PR creation failed for repo: ${repo}`);
      exitStatus++;
    }
    // force delay between PR creations
    await new Promise((resolve) => setTimeout(resolve, delay * 1000));
  }

  process.exit(exitStatus);
}

export const command = `push <branch>`;

export const describe = `push a branch from all selected repos`;

export const builder: CommandBuilder = function (yargs) {
  return yargs
    .positional(`branch`, {
      type: `string`,
      required: true,
    })
    .option(`exclude`, excludable.exclude)
    .option(`force`, forceable.force)
    .option(`open-pr`, {
      default: false,
      type: `boolean`,
    })
    .option(`pr-title`, {
      type: `string`,
    })
    .option(`pr-body`, {
      type: `string`,
    })
    .option(`delay`, {
      type: `number`,
      default: 15,
    });
};
