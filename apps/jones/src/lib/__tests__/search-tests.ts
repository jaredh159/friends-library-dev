import { describe, beforeEach, it, expect } from 'vitest';
import type { File } from '../../type';
import { searchFiles } from '../search';

describe(`searchFiles()`, () => {
  let files: Array<File>;

  beforeEach(() => {
    const adoc = `
== Chapter 1

Rofl. Foo.
Bar.
Jim Jam.
    `.trim();

    files = [
      {
        path: `journal/updated/01.adoc`,
        editedContent: adoc,
        sha: ``,
        content: ``,
      },
    ];
  });

  it(`gives us a result with the correct start and end locations`, () => {
    const [result] = searchFiles(`foo`, files);
    expect(result?.start.line).toBe(3);
    expect(result?.end.line).toBe(3);
    expect(result?.start.column).toBe(6);
    expect(result?.end.column).toBe(9);
  });

  it(`gives one line of context on each side`, () => {
    const results = searchFiles(`Bar`, files)!;
    expect(results[0]?.context[0]?.lineNumber).toBe(3);
    expect(results[0]?.context[0]?.content).toBe(`Rofl. Foo.`);
    expect(results[0]?.context[1]?.lineNumber).toBe(4);
    expect(results[0]?.context[1]?.content).toBe(`Bar.`);
    expect(results[0]?.context[2]?.lineNumber).toBe(5);
    expect(results[0]?.context[2]?.content).toBe(`Jim Jam.`);
  });

  it(`sorts results by edition type`, () => {
    files = [
      {
        path: `journal/original/01.adoc`,
        editedContent: `foobar lol`,
      },
      {
        path: `journal/updated/01.adoc`,
        editedContent: `foobar lol`,
      },
      {
        path: `journal/modernized/01.adoc`,
        editedContent: `foobar lol`,
      },
    ] as Array<File>;

    const results = searchFiles(`foobar`, files);

    expect(results[0]?.editionType).toBe(`updated`);
    expect(results[1]?.editionType).toBe(`modernized`);
    expect(results[2]?.editionType).toBe(`original`);
  });
});
