import { evaluate } from '@friends-library/evaluator';
import type { FileManifest } from '@friends-library/doc-artifacts';
import type { DocPrecursor } from '@friends-library/types';

export default async function appEbook(dpc: DocPrecursor): Promise<FileManifest[]> {
  const src = evaluate.toPdfSrcHtml(dpc);
  return [{ file: src.mergedChapterHtml() }];
}
