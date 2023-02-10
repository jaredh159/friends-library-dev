import fs from 'fs-extra';
import type { Options, FileManifest } from './types';
import { dirs } from './dirs';

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
