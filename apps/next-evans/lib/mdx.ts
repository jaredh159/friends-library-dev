import fs from 'node:fs';
import type { Lang } from '@friends-library/types';

export function fileData(): Array<{
  slug: string;
  filepath: string;
  lang: Lang;
}> {
  const mdxDir = `${process.cwd()}/mdx/`;
  return fs
    .readdirSync(mdxDir)
    .filter((file) => file.endsWith(`.mdx`))
    .map((filename) => ({
      slug: filename.replace(/\.e(s|n)\.mdx$/, ``),
      lang: filename.endsWith(`.es.mdx`) ? `es` : `en`,
      filepath: `${mdxDir}${filename}`,
    }));
}

export function source(slug: string, lang: Lang): string {
  const filepath = `${process.cwd()}/mdx/${slug}.${lang}.mdx`;
  return fs.readFileSync(filepath, `utf8`);
}
