import { toRoman } from 'roman-numerals';
import { Asciidoc, Html, HTML_DEC_ENTITIES as HEX } from '@friends-library/types';

export function htmlShortTitle(title: Asciidoc): Html {
  return htmlTitle(title.replace(/\bvolumen? \b/i, `Vol.${HEX.NON_BREAKING_SPACE}`));
}

export function htmlTitle(title: Asciidoc): Html {
  return title
    .replace(/\b(\d+)\b(.)?/g, (_, digits, next) => {
      const number = Number(digits);
      // don't convert `#&160;` to roman -- entity for space
      return (number === 160 && next === `;`) || number > 1000
        ? `${digits}${next ?? ``}`
        : `${toRoman(number)}${next ?? ``}`;
    })
    .replace(/--/g, HEX.MDASH);
}

export function utf8ShortTitle(title: Asciidoc): string {
  return htmlShortTitle(title)
    .replace(new RegExp(HEX.MDASH, `g`), `–`)
    .replace(new RegExp(HEX.NON_BREAKING_SPACE, `g`), ` `);
}
