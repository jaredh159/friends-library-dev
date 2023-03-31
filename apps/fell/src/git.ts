import { red } from 'x-chalk';
import { simpleGit as git } from 'simple-git';
import type { Repo } from './type';

export async function getCurrentBranch(repoPath: Repo): Promise<string> {
  return (await git(repoPath).branch()).current;
}

export async function isStatusClean(repoPath: Repo): Promise<boolean> {
  return (await git(repoPath).status()).isClean();
}

export async function hasBranch(repoPath: Repo, branchName: string): Promise<boolean> {
  const branch = await git(repoPath).branch();
  return branch.all.includes(branchName);
}

export async function deleteBranch(repoPath: Repo, branch: string): Promise<boolean> {
  try {
    return (await git(repoPath).deleteLocalBranch(branch)).success;
  } catch (error) {
    if (String(error).includes(`branch '${branch}' not found`)) {
      return false;
    }
    throw error;
  }
}

export async function sync(repoPath: Repo): Promise<void> {
  try {
    const branch = await getCurrentBranch(repoPath);
    await git(repoPath).pull(`origin`, branch, [`--ff-only`]);
  } catch (error) {
    red(`Error: git.sync(${repoPath})`);
    throw error;
  }
}

// like `git add . && git commit -am <message>`
export async function commitAll(repoPath: Repo, message: string): Promise<any> {
  const repo = git(repoPath);
  await repo.add(`.`);
  await repo.commit(message);
}

export async function push(
  repoPath: Repo,
  branch: string,
  force = false,
  remoteName = `origin`,
): Promise<void> {
  await git(repoPath).push(remoteName, branch, force ? [`--force`] : []);
}

export async function isAheadOfMaster(repoPath: Repo): Promise<boolean> {
  return (await git(repoPath).status()).ahead > 0;
}

export async function getHeadCommitMessage(repoPath: Repo): Promise<string> {
  const log = await git(repoPath).log({ maxCount: 1 });
  if (log.latest === null) {
    throw new Error(`No commits found in repo: ${repoPath}`);
  }
  return log.latest.message;
}

export async function checkoutBranch(repoPath: Repo, branchName: string): Promise<void> {
  await git(repoPath).checkout(branchName);
}

export async function checkoutNewBranch(
  repoPath: Repo,
  branchName: string,
): Promise<void> {
  await git(repoPath).checkoutLocalBranch(branchName);
}
