import glob from 'glob';
import { describe, beforeEach, it, expect, vi } from 'vitest';
import { getRepos, getBranchMap, getStatusGroups } from '../repos';
import * as git from '../git';

vi.mock(`glob`);
vi.mock(`../git`);

type Mock = ReturnType<typeof vi.fn>;

describe(`getBranchMap()`, () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it(`returns correct map when all on master`, async () => {
    (git.getCurrentBranch as Mock).mockResolvedValue(`master`);
    const map = await getBranchMap([`repo1`, `repo2`]);
    expect(map.size).toBe(1);
    expect(map.get(`master`)).toEqual([`repo1`, `repo2`]);
  });
});

describe(`getRepos()`, () => {
  beforeEach(() => {
    vi.resetAllMocks();
    (glob.sync as Mock).mockReturnValueOnce([`en/repo-1`, `en/repo-2`, `es/repo-3`]);
  });

  it(`returns all dirs when no exclude`, async () => {
    const repos = await getRepos([]);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`, `es/repo-3`]);
  });

  it(`returns dirs excluding single excluded`, async () => {
    const repos = await getRepos([`repo-3`]);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`]);
  });

  it(`returns dirs excluding double excluded`, async () => {
    const repos = await getRepos([`repo-3`, `repo-1`]);
    expect(repos).toEqual([`en/repo-2`]);
  });

  it(`excludes any repo path matching exclude string`, async () => {
    const repos = await getRepos([`repo`]);
    expect(repos).toEqual([]);
  });

  it(`returns all repos if branch not specified`, async () => {
    const repos = await getRepos([]);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`, `es/repo-3`]);
  });

  it(`returns only repos on branch specified`, async () => {
    (git.getCurrentBranch as Mock).mockResolvedValueOnce(`master`);
    (git.getCurrentBranch as Mock).mockResolvedValueOnce(`master`);
    (git.getCurrentBranch as Mock).mockResolvedValueOnce(`feature-x`);
    const repos = await getRepos([], `master`);
    expect(repos).toEqual([`en/repo-1`, `en/repo-2`]);
  });
});

describe(`getStatusGroups()`, () => {
  it(`separates repos into clean and dirty`, async () => {
    (git.isStatusClean as Mock).mockResolvedValueOnce(true);
    (git.isStatusClean as Mock).mockResolvedValueOnce(false);
    (git.isStatusClean as Mock).mockResolvedValueOnce(true);
    const { clean, dirty } = await getStatusGroups([`1`, `2`, `3`]);
    expect(clean).toEqual([`1`, `3`]);
    expect(dirty).toEqual([`2`]);
  });
});
