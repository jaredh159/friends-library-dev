import fs from 'fs';
import { basename } from 'path';
import { sync as glob } from 'glob';
import FsDocPrecursor from '../FsDocPrecursor';

export default function asciidoc(dpc: FsDocPrecursor, isolate?: number): void {
  let pattern = `*`;
  if (isolate) {
    pattern = `${isolate < 10 ? `0` : ``}${isolate}*`;
  }

  const paths = glob(`${dpc.fullPath}/${pattern}.adoc`);
  const files = paths.map((path) => ({ path, adoc: fs.readFileSync(path, `utf-8`) }));
  dpc.asciidocFiles = files.map((f) => ({ adoc: f.adoc, filename: basename(f.path) }));
}
