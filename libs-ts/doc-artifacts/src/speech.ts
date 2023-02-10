import fs from 'fs-extra';
import { FileManifest } from '@friends-library/types';
import { dirs } from './dirs';
import { Options } from './types';

export default async function speech(
  manifest: FileManifest,
  filenameNoExt: string,
  opts: Options,
): Promise<string> {
  const { ARTIFACT_DIR, SRC_DIR } = dirs(opts);
  fs.ensureDirSync(SRC_DIR);
  const filepath = `${ARTIFACT_DIR}/${filenameNoExt}.html`;
  await fs.writeFile(filepath, manifest.file);
  return filepath;
}
