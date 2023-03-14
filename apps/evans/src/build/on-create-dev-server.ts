import { GatsbyNode, CreateDevServerArgs } from 'gatsby';
import { podcast } from '../lib/xml';
import * as api from './api';

const onCreateDevServer: GatsbyNode['onCreateDevServer'] = async ({
  app,
}: CreateDevServerArgs) => {
  (await api.queryEditions()).forEach(({ edition, document, friend }) => {
    if (!edition.audio || edition.isDraft || !edition.impression) {
      return;
    }
    app.get(
      `/${edition.audio.files.podcast.hq.sourcePath}`,
      async (req: any, res: any) => {
        res.type(`application/xml`);
        res.send(await podcast(edition, document, friend, `HQ`));
      },
    );
    app.get(
      `/${edition.audio.files.podcast.lq.sourcePath}`,
      async (req: any, res: any) => {
        res.type(`application/xml`);
        res.send(await podcast(edition, document, friend, `LQ`));
      },
    );
  });
};

export default onCreateDevServer;
