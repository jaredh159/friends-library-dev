import path from 'path';
import { execSync } from 'child_process';
import { FsDocPrecursor } from '../types';

export default function revision(dpc: FsDocPrecursor): void {
  const cmd = `git log --max-count=1 --pretty="%h|%ct" -- .`;
  const cwd = path.resolve(dpc.fullPath);
  const [sha, timestamp] = execSync(cmd, { cwd }).toString().split(`|`);

  if (!sha || !timestamp) {
    throw new Error(`Could not determine git revision info for path: ${dpc.path}`);
  }

  dpc.revision = {
    timestamp: Number(timestamp),
    url: revisionUrl(dpc, sha),
    sha,
  };
}

function revisionUrl(dpc: FsDocPrecursor, sha: string): string {
  const org = dpc.lang === `en` ? `friends-library` : `biblioteca-de-los-amigos`;
  return [
    `https://github.com/${org}`,
    dpc.friendSlug,
    `tree`,
    sha,
    dpc.documentSlug,
    dpc.editionType,
  ].join(`/`);
}
