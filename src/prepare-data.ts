import '@friends-library/env/load';
import fs from 'fs';
import { exec } from 'child_process';
import fetch from 'node-fetch';
import { allPublishedAudiobooks } from '@friends-library/friends/query';
import { Edition } from '@friends-library/friends';
import env from '@friends-library/env';

const { FLP_API_URL } = env.require(`FLP_API_URL`);
const audiobooks: Edition[] = process.argv.includes(`--empty`)
  ? []
  : allPublishedAudiobooks(`en`).concat(allPublishedAudiobooks(`es`));

async function main(): Promise<void> {
  const promises = audiobooks.map((audiobook) => {
    return fetch(`${FLP_API_URL}/cover-props/v1/${audiobook.path}`)
      .then((res) => {
        if (res.status !== 200) {
          throw new Error(`Failed to fetch cover props for ${audiobook.path}`);
        }
        return res.json();
      })
      .then((json) => [audiobook.path, json]);
  });

  const map = Object.fromEntries(await Promise.all(promises));
  fs.writeFileSync(
    `${__dirname}/cover-props.ts`,
    [
      `/* eslint-disable */`,
      `import { CoverProps } from '@friends-library/types';`,
      ``,
      `const map: Record<string, CoverProps | undefined> = ${JSON.stringify(map)}`,
      ``,
      `export default map;`,
    ].join(`\n`),
  );

  exec(`prettier --write ${__dirname}/cover-props.ts`);

  const partTitles: Record<string, string[]> = {};
  audiobooks.forEach((audiobook) => {
    /* eslint-disable-next-line @typescript-eslint/no-non-null-assertion */
    partTitles[audiobook.path] = audiobook.audio!.parts.map((p) => p.title);
  });

  fs.writeFileSync(
    `${__dirname}/part-titles.ts`,
    [
      `/* eslint-disable */`,
      `const map: Record<string, string[]> = ${JSON.stringify(partTitles)}`,
      ``,
      `export default map;`,
    ].join(`\n`),
  );

  exec(`prettier --write ${__dirname}/part-titles.ts`);
}

main();
