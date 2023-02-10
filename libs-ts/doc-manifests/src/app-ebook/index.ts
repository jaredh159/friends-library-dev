import { evaluate as eval } from '@friends-library/evaluator';
import type { FileManifest } from '@friends-library/doc-artifacts';
import type { DocPrecursor } from '@friends-library/types';

export default async function appEbook(dpc: DocPrecursor): Promise<FileManifest[]> {
  const src = eval.toPdfSrcHtml(dpc);
  return [{ file: src.mergedChapterHtml() }];
}
