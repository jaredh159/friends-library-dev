import fs from 'fs';
import stripIndent from 'strip-indent';
import { DocPrecursor, genericDpc } from '@friends-library/types';
import compile from '../eval-speech';

describe(`compile()`, () => {
  it(`adds correct document start/end metadata`, () => {
    const text = getCompiled(`== Chapter 1\n\nHello world.`);
    const expected = stripIndent(`
      JOURNAL OF GEORGE FOX

      by GEORGE FOX


      CHAPTER 1

      Hello world.
      
      THE END.


      Published by FRIENDS LIBRARY PUBLISHING.

      Download free books from early members of the Religious Society of Friends (Quakers) in a variety of formats at www.friendslibrary.com.
      
      Public domain in the USA.

      Contact the publishers at info@friendslibrary.com.

      ISBN: 978-1-64476-029-1

      Text revision: 327ceb2 - 1/22/2021
    `);
    expect(text).toBe(expected.trim());
  });

  test.each(getTestCases())(`%s`, (_, files, expected) => {
    const text = getCompiled(...files.map((f) => f.adoc));
    const lines = text.split(`\n`).slice(5);
    const body = lines.slice(0, -15).join(`\n`);
    expect(body).toBe(expected);
  });
});

type TestCase = [
  title: string,
  files: Array<{ adoc: string; filename: string }>,
  expected: string,
];

function getTestCases(): Array<TestCase> {
  const file = fs.readFileSync(`${__dirname}/speech-tests.adoc`, `utf-8`);
  const tests = file.split(/## /g);
  consume(tests, `comment`);
  const cases: TestCase[] = tests.map((block) => {
    const lines = block.split(`\n`);
    const title = lines.shift() ?? ``;
    consume(lines, `comment`);
    consume(lines, `empty`);
    const files: Array<{ adoc: string; filename: string }> = [];

    while (lines[0] === `****`) {
      consume(lines, `adoc-delim`);
      const adocLines: string[] = [];
      while (lines[0] !== `****`) {
        adocLines.push(lines.shift() ?? ``);
      }
      files.push({
        adoc: adocLines.join(`\n`),
        filename: `0${files.length + 1}-journal.adoc`,
      });
      consume(lines, `adoc-delim`);
      consume(lines, `empty`);
    }

    consume(lines, `text-delim`);
    const textLines: string[] = [];
    while (lines[0] !== `++++`) {
      textLines.push(lines.shift() ?? ``);
    }
    return [title, files, textLines.join(`\n`)];
  });
  const isolated = cases.filter(([title]) => title.includes(`(only)`));
  return isolated.length ? ([isolated[0]] as TestCase[]) : cases;
}

function consume(
  lines: string[],
  type: 'comment' | 'empty' | 'adoc-delim' | 'text-delim',
) {
  const consumed = lines.shift();
  if (consumed === undefined) {
    throw new Error(`Nothing to consume, expected: ${type}`);
  } else if (type === `adoc-delim` && consumed !== `****`) {
    throw new Error(`Expected to consume "${type}", got ${consumed}`);
  } else if (type === `text-delim` && consumed !== `++++`) {
    throw new Error(`Expected to consume "${type}", got ${consumed}`);
  } else if (type === `empty` && consumed !== ``) {
    throw new Error(`Expected to consume "${type}", got ${consumed}`);
  } else if (type === `comment` && !consumed.startsWith(`// `)) {
    throw new Error(`Expected to consume "${type}", got ${consumed}`);
  }
}

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
