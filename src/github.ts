import { Octokit } from '@octokit/rest';
import env from '@friends-library/env';

export async function openPullRequest(
  repo: string,
  branch: string,
  title: string,
  body = ``,
): Promise<number | false> {
  try {
    const {
      data: { number },
    } = await getClient().request(`POST /repos/:owner/:repo/pulls`, {
      repo,
      title,
      owner: `friends-library`,
      head: branch,
      base: `master`,
      body,
      maintainer_can_modify: true,
    });
    return number;
  } catch (e) {
    return false;
  }
}

function getClient(): Octokit {
  const { FELL_GITHUB_TOKEN } = env.require(`FELL_GITHUB_TOKEN`);
  return new Octokit({
    auth: `token ${FELL_GITHUB_TOKEN}`,
  });
}
