import fs from 'fs';
import { describe, beforeEach, vi, it, expect } from 'vitest';
import glob from 'glob';
import lintPath from '../lint-path';

vi.mock(`fs`);

type Mock = ReturnType<typeof vi.fn>;

describe(`lintPath()`, () => {
  beforeEach(() => {
    glob.sync = vi.fn();
  });

  it(`throws if you pass a non-existent full path`, () => {
    (fs.existsSync as Mock).mockReturnValue(false);
    expect(() => lintPath(`/path/to/foo.adoc`)).toThrowError(/does not exist/);
  });

  it(`throws if the path contains no asciidoc files`, () => {
    (fs.existsSync as Mock).mockReturnValue(true);
    (glob.sync as Mock).mockReturnValue([]); // <-- no files
    expect(() => lintPath(`/en/george-fox/`)).toThrowError(/No files/);
  });

  it(`lints the globbed paths and returns map of lint data`, () => {
    (fs.existsSync as Mock).mockReturnValue(true);
    (glob.sync as Mock).mockReturnValue([`/foo.adoc`]);
    (fs.readFileSync as Mock).mockReturnValue({
      toString: () => `== C1\n\n® bad char\n`,
    });

    const lints = lintPath(`/`);

    expect(lints.count()).toBe(1);

    expect(lints.toArray()).toEqual([
      [
        `/foo.adoc`,
        {
          path: `/foo.adoc`,
          adoc: `== C1\n\n® bad char\n`,
          lints: [
            {
              type: `error`,
              rule: `invalid-characters`,
              column: 1,
              line: 3,
              message: expect.any(String),
            },
          ],
        },
      ],
    ]);
  });
});
