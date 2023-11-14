import { describe, test, it, expect, beforeEach } from 'vitest';
import { documentDate } from '../date';

describe(`documentDate()`, () => {
  let document: Parameters<typeof documentDate>[0];
  let friend: Parameters<typeof documentDate>[1];

  beforeEach(() => {
    document = { directoryPath: `/`, published: undefined };
    friend = { born: undefined, died: undefined, isCompilations: false };
  });

  it(`should use published date when present`, () => {
    document.published = 1710;
    friend.died = 1733;
    expect(documentDate(document, friend)).toBe(1710);
  });

  it(`should use death date for a friend who lived to be less than 31`, () => {
    friend.born = 1700;
    friend.died = 1725;
    expect(documentDate(document, friend)).toBe(1725);
  });

  it(`should guess 10 years less than death if we only have a death date`, () => {
    friend.died = 1740;
    expect(documentDate(document, friend)).toBe(1730);
  });

  it(`should use 75% of age`, () => {
    friend.born = 1700;
    friend.died = 1800;
    expect(documentDate(document, friend)).toBe(1775);
  });

  test(`compilations can have no determinable date`, () => {
    friend.isCompilations = true;
    expect(documentDate(document, friend)).toBe(-1);
  });

  test(`non compilations should throw if no date can be found`, () => {
    expect(() => documentDate(document, friend)).toThrow();
  });
});
