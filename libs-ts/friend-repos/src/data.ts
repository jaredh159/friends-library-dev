import fetch from 'node-fetch';
import { Lang } from '@friends-library/types';

interface Repo {
  lang: Lang;
  slug: string;
  repo: string;
  sshCloneUrl: string;
  httpsCloneUrl: string;
}

export default async function data(): Promise<Repo[]> {
  const fetches = await Promise.all([
    fetchApiPage(`en`, 1),
    fetchApiPage(`en`, 2),
    fetchApiPage(`es`, 1),
  ]);
  return fetches.flat();
}

async function fetchApiPage(lang: Lang, page: number): Promise<Repo[]> {
  const headers: Record<string, string> = {};
  if (process.env.GITHUB_TOKEN) {
    headers.Authorization = `token ${process.env.GITHUB_TOKEN}`;
  }

  const org = lang === `es` ? `biblioteca-de-los-amigos` : `friends-library`;
  const uri = `https://api.github.com/orgs/${org}/repos?per_page=100&page=${page}`;
  const res = await fetch(uri, { headers });
  const repos = (await res.json()) as Record<string, string>[];

  return repos
    .filter((repo) => repo.name !== `friends-library`)
    .map((repo) => ({
      lang,
      slug: repo.name ?? ``,
      repo: repo.full_name ?? ``,
      sshCloneUrl: repo.ssh_url ?? ``,
      httpsCloneUrl: repo.clone_url ?? ``,
    }));
}
