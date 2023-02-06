import ChapterResult from '../result/ChapterResult';
import { getTestCases } from './adoc-test-case';
import * as evaluate from '../eval-html';

const SUPPLY_OMITTED_CHAPTER_HEADINGS = true;
const DONT_SUPPLY_OMITTED_CHAPTER_HEADINGS = false;

describe(`evaluate.toPdfSrcHtml()`, () => {
  const cases = getTestCases(
    `html-tests.adoc`,
    evaluate.toPdfSrcHtml,
    (src) => src.mergedChapterHtml(),
    SUPPLY_OMITTED_CHAPTER_HEADINGS,
  );
  test.each(cases)(`%s`, (_, expected, actual) => {
    expect(actual).toBe(expected);
  });
});

describe(`evaluate.toEbookSrcHtml()`, () => {
  const cases = getTestCases(
    `ebook-tests.adoc`,
    evaluate.toEbookSrcHtml,
    (src) => src.chapters.map((c: ChapterResult) => c.content).join(`\n`),
    SUPPLY_OMITTED_CHAPTER_HEADINGS,
  );
  test.each(cases)(`%s`, (_, expected, actual) => {
    expect(actual).toBe(expected);
  });
});

describe(`evaluate.toEbookSrcHtml() [footnotes]`, () => {
  const cases = getTestCases(
    `ebook-notes-tests.adoc`,
    evaluate.toEbookSrcHtml,
    (src) => src.notesContentHtml,
    DONT_SUPPLY_OMITTED_CHAPTER_HEADINGS,
  );
  test.each(cases)(`%s`, (_, expected, actual) => {
    expect(actual).toBe(expected);
  });
});

describe(`evaluate.toPdfSrcHtml() [epigraphs]`, () => {
  const cases = getTestCases(
    `epigraph-tests.adoc`,
    evaluate.toPdfSrcHtml,
    (src) => src.epigraphHtml,
    DONT_SUPPLY_OMITTED_CHAPTER_HEADINGS,
  );
  test.each(cases)(`%s`, (_, expected, actual) => {
    expect(actual).toBe(expected);
  });
});
