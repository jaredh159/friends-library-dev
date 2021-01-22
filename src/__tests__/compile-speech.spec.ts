import stripIndent from 'strip-indent';
import { DocPrecursor, genericDpc } from '@friends-library/types';
import compile from '../';

describe(`compile()`, () => {
  it(`sets book title and author as first lines`, () => {
    const dpc = getDpc(`== Chapter 1\n\nHello world`);
    const lines = compile(dpc).split(`\n`);
    expect(lines[0]).toBe(`JOURNAL OF GEORGE FOX`);
    expect(lines[1]).toBe(``);
    expect(lines[2]).toBe(`by GEORGE FOX`);
  });

  it(`handles hello world book`, () => {
    const text = getCompiled(`== Chapter 1\n\nHello world.`);
    const expected = stripIndent(`
      JOURNAL OF GEORGE FOX

      by GEORGE FOX


      Chapter 1

      Hello world.
    `);
    expect(text).toBe(expected.trim());
  });
});

function getDpc(...files: string[]): DocPrecursor {
  const dpc = genericDpc();
  files.forEach((adoc, idx) => {
    dpc.asciidocFiles[idx] = {
      adoc: stripIndent(adoc.trim() + `\n`),
      filename: `0${idx + 1}-journal.adoc`,
    };
  });
  return dpc;
}

function getCompiled(...files: string[]): string {
  return compile(getDpc(...files));
}
