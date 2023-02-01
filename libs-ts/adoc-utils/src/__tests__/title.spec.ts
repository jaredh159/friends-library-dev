import { describe, it, expect } from '@jest/globals';
import { htmlTitle, htmlShortTitle, utf8ShortTitle } from '../title';

describe(`htmlTitle`, () => {
  it(`should turn double-dash into emdash entity`, () => {
    expect(htmlTitle(`Foo -- bar`)).toBe(`Foo &#8212; bar`);
  });

  it(`should change trailing digits into roman numerals`, () => {
    expect(htmlTitle(`Foo 3`)).toBe(`Foo III`);
  });

  it(`should not change years to roman numerals`, () => {
    expect(htmlTitle(`Chapter 9. Letters from 1818--1820`)).toBe(
      `Chapter IX. Letters from 1818&#8212;1820`,
    );
  });
});

describe(`htmlShortTitle`, () => {
  it(`should shorten volume to Vol.`, () => {
    expect(htmlShortTitle(`Foo -- Volume 1`)).toBe(`Foo &#8212; Vol.&#160;I`);
  });

  it(`should shorten spanish volumen to Vol.`, () => {
    expect(htmlShortTitle(`Foo -- volumen 4`)).toBe(`Foo &#8212; Vol.&#160;IV`);
  });
});

describe(`utf8ShortTitle`, () => {
  it(`should shorten without turning years into roman numerals`, () => {
    expect(utf8ShortTitle(`Chapter 9. Letters from 1818--1820`)).toBe(
      `Chapter IX. Letters from 1818–1820`,
    );
  });
});
