import fs from 'fs';
import prettier from 'prettier';
import stripIndent from 'strip-indent';
import { DocPrecursor, genericDpc } from '@friends-library/types';
import evalHtml from '../eval-html';

describe(`evalHtml()`, () => {
  test.each(getTestCases())(`%s`, (_, files, expected) => {
    const chapters = getEvald(...files.map((f) => f.adoc));
    const evaled = format(chapters.join(``));
    console.log(evaled);
    expect(evaled).toBe(format(expected));
  });
});

type TestCase = [
  title: string,
  files: Array<{ adoc: string; filename: string }>,
  expected: string,
];

function getTestCases(): Array<TestCase> {
  const file = fs.readFileSync(`${__dirname}/html-tests.adoc`, `utf-8`);
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

function getEvald(...files: string[]): string[] {
  return evalHtml(getDpc(...files)).chapters;
}

function format(rawHtml: string): string {
  const preprocessed = rawHtml
    .replace(/\n/g, ``)
    .replace(/  +/g, ` `)
    .replace(/> </g, `><`)
    .replace(/ </g, `<`)
    .replace(/> /g, `>`);
  return prettier.format(preprocessed, {
    parser: `html`,
    htmlWhitespaceSensitivity: `ignore`,
  });
}
