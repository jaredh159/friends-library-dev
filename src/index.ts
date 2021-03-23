import pdf from './pdf';
import epub from './epub';
import mobi from './mobi';
import speech from './speech';
import { FileManifest } from '@friends-library/types';
import { PdfOptions, EbookOptions } from './types';

export { pdf, epub, mobi, speech };
export { deleteNamespaceDir, dirs } from './dirs';

export async function create(
  manifest: FileManifest,
  filenameNoExt: string,
  options: PdfOptions & EbookOptions,
): Promise<string> {
  const numFiles = Object.keys(manifest).length;
  if (numFiles === 1) {
    return speech(manifest, filenameNoExt, options);
  } else if (numFiles < 4) {
    return pdf(manifest, filenameNoExt, options);
  } else if (manifest[`OEBPS/nav.xhtml`].includes(`http-equiv`)) {
    return mobi(manifest, filenameNoExt, options);
  } else {
    return epub(manifest, filenameNoExt, options);
  }
}
