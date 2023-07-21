import { describe, test, expect } from 'vitest';
import { ChapterResult } from '@friends-library/evaluator';
import { shouldUseMultiColLayout, multiColTocParts } from '../frontmatter';

describe(`multiColTocParts()`, () => {
  const cases = [
    [
      new ChapterResult(
        0,
        ``,
        `Forward by the Editor`,
        false,
        undefined,
        `Forward by the Editor`,
      ),
      [``, `Forward by the Editor`],
    ],
    [
      new ChapterResult(
        1,
        ``,
        `Chapter I &#8212; On Conversion and Regeneration`,
        false,
        1,
        `On Conversion and Regeneration`,
      ),
      [`I`, `On Conversion and Regeneration`],
    ],
    [
      new ChapterResult(
        2,
        ``,
        `Chapter II — The Worship Ordained of God`,
        false,
        2,
        `The Worship Ordained of God Under the Christian Dispensation`,
      ),
      [`II`, `The Worship Ordained of God`], // <-- should use short title sans prefix
    ],
    [
      new ChapterResult(
        3,
        ``,
        `Chapter III — Baptism, Worship, and Partaking of the Flesh and Blood`,
        false,
        3,
        `Baptism, Worship, and Partaking of the Flesh and Blood`,
      ),
      [`III`, `Baptism, Worship, and Partaking of the Flesh and Blood`],
    ],
    [
      new ChapterResult(
        4,
        ``,
        `Concluding Observations`,
        false,
        undefined,
        `Concluding Observations`,
      ),
      [``, `Concluding Observations`],
    ],
  ] as const;

  test.each(cases)(`chapter converted to multi-col parts`, (chapter, expected) => {
    expect(multiColTocParts(chapter)).toEqual(expected);
  });
});

describe(`shouldUseMultiColLayout()`, () => {
  const BARE_TITLE = new ChapterResult(0, ``, `Preface`, false, undefined, `Preface`);
  const INTERMEDIATE_TITLE = new ChapterResult(1, ``, `V. II`, true, undefined, `V. II`);
  const BARE_CHAPTER = new ChapterResult(2, ``, `Chapter 2`, false, 2);
  const NAMED_CHAPTER = new ChapterResult(3, ``, `Travels`, false, 3, `Travels`);

  test(`doc with mostly named chapters should use multi-col layout`, () => {
    const doc = [BARE_TITLE, NAMED_CHAPTER, NAMED_CHAPTER, NAMED_CHAPTER, NAMED_CHAPTER];
    expect(shouldUseMultiColLayout(doc)).toBe(true);
  });

  test(`doc with mostly bare chapters should not use multi-col layout`, () => {
    const doc = [BARE_TITLE, BARE_CHAPTER, BARE_CHAPTER, BARE_CHAPTER, BARE_CHAPTER];
    expect(shouldUseMultiColLayout(doc)).toBe(false);
  });

  test(`doc with only bare title sections should not use multi-col layout`, () => {
    const doc = [BARE_TITLE, BARE_TITLE, BARE_TITLE, BARE_TITLE, BARE_TITLE];
    expect(shouldUseMultiColLayout(doc)).toBe(false);
  });

  test(`doc with without majority of named chapters should not use multi-col`, () => {
    const doc = [BARE_TITLE, BARE_CHAPTER, BARE_CHAPTER, NAMED_CHAPTER, NAMED_CHAPTER];
    expect(shouldUseMultiColLayout(doc)).toBe(false);
  });

  test(`intermediate titles are not counted when determining layout`, () => {
    const doc = [
      BARE_TITLE,
      INTERMEDIATE_TITLE,
      NAMED_CHAPTER,
      INTERMEDIATE_TITLE,
      NAMED_CHAPTER,
      INTERMEDIATE_TITLE,
      NAMED_CHAPTER,
      INTERMEDIATE_TITLE,
      NAMED_CHAPTER,
    ];
    expect(shouldUseMultiColLayout(doc)).toBe(true);
  });
});
