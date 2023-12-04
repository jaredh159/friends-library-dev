import fs from 'fs-extra';
import env from '@friends-library/env';
import type { GatsbyNode } from 'gatsby';
import { podcast } from '../lib/xml';
import { LANG } from '../env';
import { sendSearchDataToAlgolia } from './algolia';
import * as api from './api';

const onPostBuild: GatsbyNode['onPostBuild'] = async () => {
  (await api.queryEditions()).forEach(async ({ edition, document, friend }) => {
    if (friend.lang === LANG && edition.audio) {
      const xmlHq = await podcast(edition, document, friend, `hq`);
      fs.outputFileSync(`./public/${edition.audio.podcastSourcePathHq}`, xmlHq);
      const xmlLq = await podcast(edition, document, friend, `lq`);
      fs.outputFileSync(`./public/${edition.audio.podcastSourcePathLq}`, xmlLq);
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
