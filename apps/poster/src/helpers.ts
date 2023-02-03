import { htmlShortTitle } from '@friends-library/adoc-utils';

export function htmlTitle(title: string, author: string): string {
  return htmlShortTitle(title.replace(author, author.replace(/ +/g, `&nbsp;`)))
    .replace(/\bpt(\.)? (I|\d)/, `pt$1&nbsp;$2`)
    .replace(
      /((Chapter|Capítulo|Section|Sección|Parte?) \d+) - /,
      `<small>$1:</small><br />`,
    );
}
