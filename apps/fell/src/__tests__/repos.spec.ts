import { describe, beforeEach, it, expect, vi } from 'vitest';
import { getRepos, getBranchMap, getStatusGroups } from '../repos';
import * as git from '../git';

vi.mock(`../git`);
const glob = () => [`en/repo-1`, `en/repo-2`, `es/repo-3`];

describe(`getBranchMap()`, () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it(`returns correct map when all on master`, async () => {
    vi.mocked(git.getCurrentBranch).mockResolvedValue(`master`);
    const map = await getBranchMap([`repo1`, `repo2`]);
    expect(map.size).toBe(1);
    expect(map.get(`master`)).toEqual([`repo1`, `repo2`]);
  });
});

describe(`getRepos()`, () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it(`returns all dirs when no exclude`, async () => {
    const repos = await getRepos([], undefined, glob);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`, `es/repo-3`]);
  });

  it(`returns dirs excluding single excluded`, async () => {
    const repos = await getRepos([`repo-3`], undefined, glob);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`]);
  });

  it(`returns dirs excluding double excluded`, async () => {
    const repos = await getRepos([`repo-3`, `repo-1`], undefined, glob);
    expect(repos).toEqual([`en/repo-2`]);
  });

  it(`excludes any repo path matching exclude string`, async () => {
    const repos = await getRepos([`repo`], undefined, glob);
    expect(repos).toEqual([]);
  });

  it(`returns all repos if branch not specified`, async () => {
    const repos = await getRepos([], undefined, glob);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`, `es/repo-3`]);
  });

  it(`returns only repos on branch specified`, async () => {
    vi.mocked(git.getCurrentBranch).mockResolvedValueOnce(`master`);
    vi.mocked(git.getCurrentBranch).mockResolvedValueOnce(`master`);
    vi.mocked(git.getCurrentBranch).mockResolvedValueOnce(`feature-x`);
    const repos = await getRepos([], `master`, glob);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`]);
  });
});

describe(`getStatusGroups()`, () => {
  it(`separates repos into clean and dirty`, async () => {
    vi.mocked(git.isStatusClean).mockResolvedValueOnce(true);
    vi.mocked(git.isStatusClean).mockResolvedValueOnce(false);
    vi.mocked(git.isStatusClean).mockResolvedValueOnce(true);
    const { clean, dirty } = await getStatusGroups([`1`, `2`, `3`]);
    expect(clean).toEqual([`1`, `3`]);
    expect(dirty).toEqual([`2`]);
  });
});
