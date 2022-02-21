import fs from 'fs';
import { basename } from 'path';
import { sync as glob } from 'glob';
import { FsDocPrecursor } from '../types';

export interface HydrateAsciidocConfig {
  isolate?: number;
  chapterHeadingsOnly?: boolean;
}

export default function asciidoc(
  dpc: FsDocPrecursor,
  config: HydrateAsciidocConfig = {},
): void {
  let pattern = `*`;
  if (config.isolate) {
    pattern = `${config.isolate < 10 ? `0` : ``}${config.isolate}*`;
  }

  const paths = glob(`${dpc.fullPath}/${pattern}.adoc`);
  let files = paths.map((path) => ({ path, adoc: fs.readFileSync(path, `utf-8`) }));

  if (config.chapterHeadingsOnly) {
    files = files.map((file) => {
      const lines = file.adoc.split(`\n`);
      const chHeadIdx = lines.findIndex((l) => l.startsWith(`== `));
      // this moves us past footnotes on chapter headings: `== Chapter 1^`
      const firstEmptyIdx = lines.findIndex((l, i) => i > chHeadIdx && l === ``);
      const headingOnlyAdoc = lines.slice(0, firstEmptyIdx + 1).join(`\n`);
      return { adoc: headingOnlyAdoc, path: file.path };
    });
  }

  dpc.asciidocFiles = files.map((f) => ({ adoc: f.adoc, filename: basename(f.path) }));
}
