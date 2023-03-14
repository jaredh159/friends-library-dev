import fs from 'fs-extra';
import { GatsbyNode } from 'gatsby';
import env from '@friends-library/env';
import { podcast } from '../lib/xml';
import { sendSearchDataToAlgolia } from './algolia';
import { LANG } from '../env';
import * as api from './api';

const onPostBuild: GatsbyNode['onPostBuild'] = async () => {
  (await api.queryEditions()).forEach(async ({ edition, document, friend }) => {
    if (friend.lang === LANG && edition.audio) {
      const xmlHq = await podcast(edition, document, friend, `HQ`);
      fs.outputFileSync(`./public/${edition.audio.files.podcast.hq.sourcePath}`, xmlHq);
      const xmlLq = await podcast(edition, document, friend, `LQ`);
      fs.outputFileSync(`./public/${edition.audio.files.podcast.lq.sourcePath}`, xmlLq);
    }
  });

  const { GATSBY_NETLIFY_CONTEXT, DEPLOYING } = env.get(
    `GATSBY_NETLIFY_CONTEXT`,
    `DEPLOYING`,
  );
  if (DEPLOYING && GATSBY_NETLIFY_CONTEXT === `production`) {
    await sendSearchDataToAlgolia();
  }
};

export default onPostBuild;
