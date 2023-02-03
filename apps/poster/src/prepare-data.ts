import '@friends-library/env/load';
import fs from 'fs';
import { exec } from 'child_process';
import fetch from 'cross-fetch';
import env from '@friends-library/env';
import { CoverProps, PrintSize } from '@friends-library/types';
import { gql, getClient } from '@friends-library/db';
import { GetAudios } from './graphql/GetAudios';

async function main(): Promise<void> {
  const docsRoot = env.requireVar(`DOCS_REPOS_ROOT`);
  const audios = await getAudios();
  const map: Record<string, CoverProps> = {};
  audios.forEach((audio) => {
    map[audio.edition.path] = {
      lang: audio.edition.document.friend.lang,
      title: audio.edition.document.title,
      isCompilation: audio.edition.document.friend.isCompilations,
      author: audio.edition.document.friend.name,
      size: (audio.edition.impression?.paperbackSize ?? `m`) as PrintSize,
      pages: audio.edition.impression?.paperbackVolumes[0] ?? 222,
      edition: audio.edition.type,
      isbn: audio.edition.isbn?.code ?? ``,
      blurb: audio.edition.document.description,
      ...customCode(audio.edition.document.directoryPath, docsRoot),
    };
  });
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
  audios.forEach((audio) => {
    partTitles[audio.edition.path] = audio.parts.map((p) => p.title);
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

async function getAudios(): Promise<GetAudios['audios']> {
  if (process.argv.includes(`--empty`)) {
    return [];
  }
  const client = getClient({ env: `infer_node`, process, fetch });
  const { data } = await client.query<GetAudios>({ query: QUERY });
  return data.audios.filter(({ edition }) => !edition.isDraft);
}

function customCode(
  relPath: string,
  docsRoot: string,
): Pick<CoverProps, 'customCss' | 'customHtml'> {
  let customCss = ``;
  let customHtml = ``;
  const cssPath = `${docsRoot}/${relPath}/paperback-cover.css`;
  if (fs.existsSync(cssPath)) {
    customCss = fs.readFileSync(cssPath, `utf8`);
  }
  const htmlPath = `${docsRoot}/${relPath}/paperback-cover.html`;
  if (fs.existsSync(htmlPath)) {
    customHtml = fs.readFileSync(htmlPath, `utf8`);
  }
  return { customCss, customHtml };
}

const QUERY = gql`
  query GetAudios {
    audios: getAudios {
      parts {
        title
      }
      edition {
        type
        isDraft
        path: directoryPath
        isbn {
          code
        }
        document {
          description
          title
          directoryPath
          friend {
            lang
            isCompilations
            name
          }
        }
        impression {
          paperbackSize
          paperbackVolumes
        }
      }
    }
  }
`;

main();
