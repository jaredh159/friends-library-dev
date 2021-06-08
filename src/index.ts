import pdf from './pdf';
import epub from './epub';
import mobi from './mobi';
import speech from './speech';
import appEbook from './app-ebook';
import { ArtifactType, FileManifest } from '@friends-library/types';
import { PdfOptions, EbookOptions } from './types';

export { pdf, epub, mobi, speech, appEbook };
export { deleteNamespaceDir, dirs } from './dirs';

export async function create(
  type: ArtifactType,
  manifest: FileManifest,
  filenameNoExt: string,
  options: PdfOptions & EbookOptions,
): Promise<string> {
  switch (type) {
    case `speech`:
      return speech(manifest, filenameNoExt, options);
    case `web-pdf`:
    case `paperback-cover`:
    case `paperback-interior`:
      return pdf(manifest, filenameNoExt, options);
    case `mobi`:
      return mobi(manifest, filenameNoExt, options);
    case `epub`:
      return epub(manifest, filenameNoExt, options);
    case `app-ebook`:
      return appEbook(manifest, filenameNoExt, options);
  }
}
