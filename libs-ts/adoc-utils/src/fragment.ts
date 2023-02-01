import { HTML_DEC_ENTITIES as html } from '@friends-library/types';

export function adocFragmentToHtml(adoc: string): string {
  return backtickQuotesToEntities(adoc)
    .replace(/--/g, html.MDASH)
    .replace(/ & /g, ` ${html.AMPERSAND} `)
    .trim();
}

export function backtickQuotesToEntities(asciidoc: string): string {
  const adoc = ADOC_SYNTAX;
  return asciidoc
    .replace(
      new RegExp(`${adoc.RIGHT_DOUBLE_QUOTE}${adoc.RIGHT_SINGLE_QUOTE}`, `gim`),
      `${html.RIGHT_DOUBLE_QUOTE}${html.RIGHT_SINGLE_QUOTE}`,
    )
    .replace(
      new RegExp(`${adoc.RIGHT_SINGLE_QUOTE}${adoc.RIGHT_DOUBLE_QUOTE}`, `gim`),
      `${html.RIGHT_SINGLE_QUOTE}${html.RIGHT_DOUBLE_QUOTE}`,
    )
    .replace(new RegExp(adoc.LEFT_DOUBLE_QUOTE, `gim`), html.LEFT_DOUBLE_QUOTE)
    .replace(new RegExp(adoc.RIGHT_DOUBLE_QUOTE, `gim`), html.RIGHT_DOUBLE_QUOTE)
    .replace(new RegExp(adoc.LEFT_SINGLE_QUOTE, `gim`), html.LEFT_SINGLE_QUOTE)
    .replace(new RegExp(adoc.RIGHT_SINGLE_QUOTE, `gim`), html.RIGHT_SINGLE_QUOTE);
}

export function htmlEntitiesToDecimal(adoc: string): string {
  return adoc.replace(/&hellip;/g, html.ELLIPSES);
}

export const ADOC_SYNTAX = {
  LEFT_DOUBLE_QUOTE: `"\``,
  RIGHT_DOUBLE_QUOTE: `\`"`,
  LEFT_SINGLE_QUOTE: `'\``,
  RIGHT_SINGLE_QUOTE: `\`'`,
};
