import { describe, test } from '@jest/globals';
import ChapterResult from '../result/ChapterResult';
import PdfSrcResult from '../result/PdfSrcResult';
import * as evaluate from '../eval-html';

describe(`eval.toPdfSrcHtml()`, () => {
  test(`numFootnotes computed prop`, () => {
    const result = getResult(`== Preface\n\nPara\n`);
    expect(result.numFootnotes).toBe(0);
    const result2 = getResult(`== Preface\n\nParafootnote:[fn]\n`);
    expect(result2.numFootnotes).toBe(1);
  });

  test(`configures chapter objects correctly`, () => {
    const result = getResult(`== Preface\n\nPara\n`);
    expect(result.chapters).toHaveLength(1);
    const chapter1 = result.chapters[0]!;
    expect(chapter1.id).toBe(`chapter-1`);
    expect(chapter1.slug).toBe(`chapter-1`);
    expect(chapter1.isSequenced).toBe(false);
    expect(chapter1.sequenceNumber).toBeUndefined();
    expect(chapter1.nonSequenceTitle).toBe(`Preface`);
    expect(chapter1.hasNonSequenceTitle).toBe(true);
    expect(chapter1.shortHeading).toBe(`Preface`);
    expect(chapter1.isIntermediateTitle).toBe(false);
  });

  test(`supports custom id`, () => {
    const chapter1 = firstChapter(`[#custom-id]\n== Preface\n\nPara\n`);
    expect(chapter1.id).toBe(`custom-id`);
  });

  test(`supports custom short title`, () => {
    const chapter1 = firstChapter(`[#custom, short="Pre"]\n== Preface\n\nPara\n`);
    expect(chapter1.shortHeading).toBe(`Pre`);
  });

  test(`supports sequencing`, () => {
    const chapter1 = firstChapter(`== Chapter 1\n\nPara\n`);
    expect(chapter1.isSequenced).toBe(true);
    expect(chapter1.sequenceNumber).toBe(1);
    expect(chapter1.nonSequenceTitle).toBeUndefined();
    expect(chapter1.hasNonSequenceTitle).toBe(false);
  });

  test(`supports nonSequenceTitle`, () => {
    const chapter1 = firstChapter(`== Chapter X. Conclusion\n\nPara\n`);
    expect(chapter1.isSequenced).toBe(true);
    expect(chapter1.sequenceNumber).toBe(10);
    expect(chapter1.nonSequenceTitle).toBe(`Conclusion`);
    expect(chapter1.hasNonSequenceTitle).toBe(true);
  });

  test(`rundell 1`, () => {
    const chapter1 = firstChapter(`== Chapter I: On Conversion and Regeneration`);
    expect(chapter1.isSequenced).toBe(true);
    expect(chapter1.sequenceNumber).toBe(1);
    expect(chapter1.nonSequenceTitle).toBe(`On Conversion and Regeneration`);
    expect(chapter1.hasNonSequenceTitle).toBe(true);
  });

  test(`rundell 2`, () => {
    const chapter1 = firstChapter(
      [
        `[#chapter-2, short="The Worship Ordained of God"]`,
        `== Chapter II: The Worship Ordained of God Under the Christian Dispensation`,
      ].join(`\n`),
    );
    expect(chapter1.isSequenced).toBe(true);
    expect(chapter1.sequenceNumber).toBe(2);
    expect(chapter1.shortHeading).toBe(`The Worship Ordained of God`);
    expect(chapter1.nonSequenceTitle).toBe(
      `The Worship Ordained of God Under the Christian Dispensation`,
    );
    expect(chapter1.hasNonSequenceTitle).toBe(true);
  });

  test(`block passthroughs`, () => {
    // prettier-ignore
    const adoc = [
      `== Preface`,
      ``,
      `++++`,
      `<aside>RAW HTML!</aside>`,
      `++++`
    ].join(`\n`)
    const html = firstChapter(adoc).content;
    expect(html).toContain(`<aside>RAW HTML!</aside>`);
  });

  test(`sub-word emphasis`, () => {
    const chapter1 = firstChapter(`== Preface\n\nPa__ragra__ph\n`);
    expect(chapter1.content).toContain(`Pa<em>ragra</em>ph`);
  });

  test(`xref tight wrapping`, () => {
    const chapter1 = firstChapter(`== Preface\n\n+++[+++See <<apx,Appendix.>>]\n`);
    expect(chapter1.content).toContain(`Appendix.</a>]`);
  });
});

function getResult(adoc: string): PdfSrcResult {
  return evaluate.toPdfSrcHtml({
    asciidocFiles: [{ adoc, filename: `test.adoc` }],
    lang: `en`,
  });
}

function firstChapter(adoc: string): ChapterResult {
  const pdfSrc = getResult(adoc);
  const firstCh = pdfSrc.chapters[0];
  if (!firstCh) {
    throw new Error(`Unexpected missing chapter`);
  }
  return firstCh;
}
