import fs from 'fs';
import { sync as glob } from 'glob';
import { red } from 'x-chalk';
import { query as dpcQuery } from '@friends-library/dpc-fs';

export default async function handler({ pattern }: { pattern: string }): Promise<void> {
  const dpcs = await dpcQuery.getByPattern(pattern);
  if (dpcs.length === 0) {
    red(`Pattern: \`${pattern}\` matched 0 docs.`);
    process.exit(1);
  }

  dpcs.forEach((dpc) => {
    const files = glob(`${dpc.fullPath}/*.adoc`);
    files.forEach((path) => {
      const adoc = fs.readFileSync(path).toString();
      console.log(adoc);
    });
  });
}
