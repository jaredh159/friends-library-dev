import { evaluate } from '@friends-library/evaluator';
import type { FileManifest } from '@friends-library/doc-artifacts';
import type { DocPrecursor } from '@friends-library/types';

export default async function speech(dpc: DocPrecursor): Promise<FileManifest[]> {
  return [{ file: evaluate.toSpeechHtml(dpc) }];
}
