import '@friends-library/env/load';
import * as fs from 'fs';
import { resolve } from 'path';
import exec from 'x-exec';
import env from '@friends-library/env';
import DevClient from '@friends-library/pairql/dev';
import type { FriendData } from '../types';

const ROOT = env.requireVar(`DOCS_REPOS_ROOT`);

async function main(): Promise<void> {
  const friends: FriendData[] = [];

  if (!process.env.CI) {
    const data = await DevClient.node(process).coverWebAppFriends();
    const sortedFriends = data.sort((a, b) =>
      a.alphabeticalName < b.alphabeticalName ? -1 : 1,
    );
    for (const friend of sortedFriends) {
      friends.push({
        name: friend.name,
        alphabeticalName: friend.alphabeticalName,
        description: friend.description,
        documents: friend.documents.map((doc) => ({
          lang: doc.lang,
          title: doc.title,
          description: doc.description,
          isCompilation: doc.isCompilation,
          editions: doc.editions.map((ed) => ({
            id: ed.id,
            path: ed.path,
            type: ed.type,
            pages: ed.pages?.[0] ?? 222,
            size: ed.size ?? `m`,
            isbn: ed.isbn ?? ``,
          })),
          ...getCustomCode(doc.directoryPath),
        })),
      });
    }
  }

  const destPath = resolve(__dirname, `../friends.js`);
  fs.writeFileSync(destPath, `window.Friends = ${JSON.stringify(friends)}`);
  exec(`prettier --write ${destPath}`);
}

function getCustomCode(path: string): {
  customHtml: string | null;
  customCss: string | null;
} {
  const fullPath = `${ROOT}/${path}`;
  let customCss: string | null = null;
  let customHtml: string | null = null;

  if (fs.existsSync(`${fullPath}/paperback-cover.css`)) {
    customCss = fs.readFileSync(`${fullPath}/paperback-cover.css`, `utf8`);
  }

  if (fs.existsSync(`${fullPath}/paperback-cover.html`)) {
    customHtml = fs.readFileSync(`${fullPath}/paperback-cover.html`, `utf8`);
  }
  return { customCss, customHtml };
}

main();
