import stripIndent from 'strip-indent';
import headingSequence from '../heading-sequence';

const opts = { lang: `en` as const };

describe(`headingSequence()`, () => {
  it(`lints out of order heading`, () => {
    const adoc = stripIndent(`
      == Chapter 1

      Foo bar

      ==== Bad heading

      Foo bar.
    `).trim();

    const results = headingSequence(adoc, opts);
    expect(results).toHaveLength(1);
    expect(results[0]).toEqual({
      line: 5,
      column: false,
      type: `error`,
      rule: `heading-sequence`,
      message: `No skipping heading levels (i.e., from == to ====)`,
    });
  });

  it(`does not get tripped up on example block delimiters`, () => {
    const adoc = stripIndent(`
      == Chapter 1

      Foo

      [.numbered-group]
      ====

      [.numbered]
      First, foo.

      ====
    `).trim();

    const results = headingSequence(adoc, opts);
    expect(results).toHaveLength(0);
  });
});
