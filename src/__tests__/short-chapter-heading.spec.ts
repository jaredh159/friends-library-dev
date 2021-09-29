import { test, expect, describe } from '@jest/globals';
import { Parser } from '@friends-library/parser';
import shortChapterHeading from '../short-chapter-heading';

describe(`shortChapterHeading()`, () => {
  const cases: Array<[string, string]> = [
    [`Segment "\`1\`" / Segment 2`, `Segment “1”`],
    [`Preface`, `Preface`],
    [`Preface.`, `Preface`],
    [`Forward`, `Forward`],
    [`A Warning,`, `A Warning`],
    [`Hello "\`world\`"`, `Hello “world”`],
    [`Chapter 3: Foobar`, `Chapter III &#8212; Foobar`],
    [`Chapter x`, `Chapter X`],
    [`Section 5: Lorem`, `Section V &#8212; Lorem`],
    [`Chapter 1`, `Chapter I`],
    [`Chapter 2. Hello World`, `Chapter II &#8212; Hello World`],
    [`Preface.footnote:[Hello]`, `Preface`],
    [`Chapter 9. Letters from 1818--1820`, `Chapter IX &#8212; Letters from 1818—1820`],
  ];

  test.each(cases)(`chapter title "%s" => nav text "%s"`, (input, expected) => {
    const document = Parser.parseDocument({ adoc: `== ${input}\n\nParagraph.\n` });
    const text = shortChapterHeading(document.children[0]!);
    expect(text).toBe(expected);
  });

  test(`short text prefered`, () => {
    const document = Parser.parseDocument({
      adoc: `[#ch1, short="Preface"]\n== Preface Long\n\nHello world.\n`,
    });
    const text = shortChapterHeading(document.children[0]!);
    expect(text).toBe(`Preface`);
  });
});
