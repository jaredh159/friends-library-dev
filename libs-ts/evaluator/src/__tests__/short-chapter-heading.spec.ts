import { test, expect, describe } from '@jest/globals';
import { Parser } from '@friends-library/parser';
import stripIndent from 'strip-indent';
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
    [`Epistles 77 &#8212; 106`, `Epistles 77 &#8212; 106`],
    [
      `History of the+++<br />+++People Called Quakers`,
      `History of the People Called Quakers`,
    ],
    [
      `Chapter XVI. Letters of Isaac Penington / Written Between 1658 &#8212; 1671`,
      `Chapter XVI &#8212; Letters of Isaac Penington`,
    ],
    [
      `Chapter III. How Sin is Strengthened / &amp; How it is Overcome`,
      `Chapter III &#8212; How Sin is Strengthened`,
    ],
  ];

  test.each(cases)(
    `chapter title "%s" => short chapter heading "%s"`,
    (input, expected) => {
      const document = Parser.parseDocument({ adoc: `== ${input}\n\nParagraph.\n` });
      const text = shortChapterHeading(document.children[0]!);
      expect(text).toBe(expected);
    },
  );

  test(`short text prefered`, () => {
    const document = Parser.parseDocument({
      adoc: `[#ch1, short="Preface"]\n== Preface Long\n\nHello world.\n`,
    });
    const text = shortChapterHeading(document.children[0]!);
    expect(text).toBe(`Preface`);
  });

  test(`<br /> in non sequence title replaced by space`, () => {
    const adoc = stripIndent(`
      [.intermediate-title, short="Book III"]
      == History of the+++<br />+++People Called Quakers
      
      [.division]
      === Book III.
      
      [.blurb]
      ==== From the Restoration of King Charles II to his Declaration of Indulgence.
    `);

    const document = Parser.parseDocument({ adoc: adoc.trim() + `\n` });
    const chapter = document.children[0]!;
    shortChapterHeading(chapter);
    expect(chapter.getMetaData(`nonSequenceTitle`)).toBe(
      `History of the People Called Quakers`,
    );
  });
});
