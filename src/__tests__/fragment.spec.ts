import { describe, test, expect } from '@jest/globals';
import { HTML_DEC_ENTITIES as h } from '@friends-library/types';
import { backtickQuotesToEntities, ADOC_SYNTAX as a } from '../fragment';

describe(`backTickQuotesToEntities()`, () => {
  const cases = [
    [
      `Foo ${a.LEFT_DOUBLE_QUOTE}bar${a.RIGHT_DOUBLE_QUOTE}${a.RIGHT_SINGLE_QUOTE}`,
      `Foo ${h.LEFT_DOUBLE_QUOTE}bar${h.RIGHT_DOUBLE_QUOTE}${h.RIGHT_SINGLE_QUOTE}`,
    ],
    [
      `Foo ${a.LEFT_SINGLE_QUOTE}${a.LEFT_DOUBLE_QUOTE}bar${a.RIGHT_DOUBLE_QUOTE}${a.RIGHT_SINGLE_QUOTE}`,
      `Foo ${h.LEFT_SINGLE_QUOTE}${h.LEFT_DOUBLE_QUOTE}bar${h.RIGHT_DOUBLE_QUOTE}${h.RIGHT_SINGLE_QUOTE}`,
    ],
    [
      `Foo ${a.LEFT_SINGLE_QUOTE}bar${a.RIGHT_SINGLE_QUOTE}${a.RIGHT_DOUBLE_QUOTE}`,
      `Foo ${h.LEFT_SINGLE_QUOTE}bar${h.RIGHT_SINGLE_QUOTE}${h.RIGHT_DOUBLE_QUOTE}`,
    ],
    [
      `Foo ${a.LEFT_DOUBLE_QUOTE}${a.LEFT_SINGLE_QUOTE}bar${a.RIGHT_SINGLE_QUOTE}${a.RIGHT_DOUBLE_QUOTE}`,
      `Foo ${h.LEFT_DOUBLE_QUOTE}${h.LEFT_SINGLE_QUOTE}bar${h.RIGHT_SINGLE_QUOTE}${h.RIGHT_DOUBLE_QUOTE}`,
    ],
  ];

  test.each(cases)(`%s should become %s`, (adoc, html) => {
    expect(backtickQuotesToEntities(adoc)).toBe(html);
  });
});
