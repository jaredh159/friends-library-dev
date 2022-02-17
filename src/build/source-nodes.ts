import '@friends-library/env/load';
import { GatsbyNode, SourceNodesArgs } from 'gatsby';
import filesize from 'filesize';
// @TODO can i remove Lulu as a dep? deprecate it as a lib?
// import { price } from '@friends-library/lulu';
import { query, hydrate, FsDocPrecursor } from '@friends-library/dpc-fs';
import { getDpcCache, persistDpcCache, EditionCache } from './dpc-cache';
import residences from './residences';
import * as url from '../lib/url';
import { documentDate, periodFromDate, published } from '../lib/date';
import { documentRegion } from '../lib/region';
import { APP_ALT_URL, LANG } from '../env';
import { getNewsFeedItems } from './news-feed';
import * as api from './api';

const humansize = filesize.partial({ round: 0, spacer: `` });

const sourceNodes: GatsbyNode['sourceNodes'] = async ({
  actions: { createNode },
  createNodeId,
  createContentDigest,
}: SourceNodesArgs) => {
  const allFriends = await api.queryFriends();
  const friends = allFriends.filter((f) => f.lang === LANG && f.hasNonDraftDocument);
  const dpcCache = getDpcCache();

  const newsFeedItems = getNewsFeedItems(allFriends, LANG);
  newsFeedItems.forEach((feedItem) => {
    createNode({
      ...feedItem,
      id: createNodeId(`feed-item-${feedItem.date}${feedItem.title}${feedItem.url}`),
      internal: {
        type: `NewsFeedItem`,
        contentDigest: createContentDigest(feedItem),
      },
    });
  });

  friends.forEach((friend) => {
    const documents = friend.documents.filter((doc) => doc.hasNonDraftEdition);
    const friendProps = {
      friendId: friend.id,
      name: friend.name,
      slug: friend.slug,
      gender: friend.gender,
      born: friend.born,
      died: friend.died,
      isCompilations: friend.isCompilations,
      description: friend.description,
      quotes: friend.quotes,
      relatedDocuments: friend.relatedDocuments,
      residences: residences(friend.residences),
      url: url.friendUrl(friend),
    };

    createNode({
      ...friendProps,
      id: createNodeId(`friend-${friend.id}`),
      children: documents.map((d) => createNodeId(`document-${d.id}`)),
      internal: {
        type: `Friend`,
        contentDigest: createContentDigest(friendProps),
      },
    });

    documents.forEach((document) => {
      const documentProps: Record<string, any> = {
        htmlTitle: document.htmlTitle,
        htmlShortTitle: document.htmlShortTitle,
        utf8ShortTitle: document.utf8ShortTitle,
        originalTitle: document.originalTitle,
        description: document.description,
        isCompilation: friend.isCompilations,
        isComplete: !document.incomplete,
        region: documentRegion(friend),
        date: documentDate(document, friend),
        period: periodFromDate(documentDate(document, friend)),
        url: url.documentUrl(document, friend),
        authorUrl: url.friendUrl(friend),
        documentId: document.id,
        friendSlug: friend.slug,
        authorName: friend.name,
        ogImageUrl: document.primaryEdition!.images.threeD.w700.url,
      };

      if (
        document.altLanguageDocument &&
        document.altLanguageDocument.hasNonDraftEdition
      ) {
        documentProps.altLanguageUrl = `${APP_ALT_URL}${url.documentUrl(
          document.altLanguageDocument,
          document.altLanguageDocument.friend,
        )}`;
      }

      const filteredEditions = document.editions.filter(
        (edition) => !edition.isDraft && edition.impression,
      );
      const editions = filteredEditions.map(async (edition) => {
        let dpcData: EditionCache = dpcCache.get(edition.path) || {
          initialized: false,
          customCode: { css: {}, html: {} },
        };
        if (!dpcData.initialized) {
          const dpc = (await getDpcs()).find((dpc) => dpc.path === edition.path);
          if (dpc) {
            hydrate.customCode(dpc);
            dpcData = {
              initialized: true,
              customCode: dpc.customCode,
            };
            dpcCache.set(edition.path, dpcData);
            persistDpcCache(dpcCache);
          }
        }

        const impression = edition.impression;
        if (!impression) {
          throw new Error(`Unexpected missing EditionImpression for ${edition.path}`);
        }

        return {
          ...published(impression.createdAt, LANG),
          friendSlug: friend.slug,
          documentSlug: document.slug,
          printSize: impression.paperbackSize,
          pages: impression.paperbackVolumes,
          downloadUrl: {
            web_pdf: impression.files.ebook.pdf.logUrl,
            epub: impression.files.ebook.epub.logUrl,
            mobi: impression.files.ebook.mobi.logUrl,
            speech: impression.files.ebook.speech.logUrl,
          },
          price: impression.paperbackPriceInCents,
          customCode: dpcData.customCode,
          numChapters: edition.chapters.length,
          audio: edition.audio
            ? {
                reader: edition.audio.reader,
                added: edition.audio.createdAt,
                complete: !edition.audio.isIncomplete,
                duration: edition.audio.humanDurationClock,
                publishedDate: published(edition.audio.createdAt, LANG).publishedDate,
                m4bFilesizeHq: humansize(edition.audio.m4bSizeHq),
                m4bFilesizeLq: humansize(edition.audio.m4bSizeLq),
                mp3ZipFilesizeHq: humansize(edition.audio.mp3ZipSizeHq),
                mp3ZipFilesizeLq: humansize(edition.audio.mp3ZipSizeLq),
                m4bUrlHq: edition.audio.files.m4b.hq.logUrl,
                m4bUrlLq: edition.audio.files.m4b.lq.logUrl,
                mp3ZipUrlHq: edition.audio.files.mp3s.hq.logUrl,
                mp3ZipUrlLq: edition.audio.files.mp3s.lq.logUrl,
                podcastUrlHq: edition.audio.files.podcast.hq.logUrl,
                podcastUrlLq: edition.audio.files.podcast.lq.logUrl,
                externalPlaylistIdHq: edition.audio.externalPlaylistIdHq,
                externalPlaylistIdLq: edition.audio.externalPlaylistIdLq,
                parts: edition.audio.parts.map((part) => ({
                  title: part.title,
                  chapters: part.chapters,
                  externalIdHq: part.externalIdHq,
                  externalIdLq: part.externalIdLq,
                })),
              }
            : undefined,
        };
      });

      createNode({
        ...documentProps,
        editions,
        id: createNodeId(`document-${document.id}`),
        parent: createNodeId(`friend-${friend.id}`),
        internal: {
          type: `Document`,
          contentDigest: createContentDigest(documentProps),
        },
      });
    });
  });
};

export default sourceNodes;

let dpcs: FsDocPrecursor[] | null = null;

async function getDpcs(): Promise<FsDocPrecursor[]> {
  if (dpcs) return dpcs;
  dpcs = await query.getByPattern();
  return dpcs;
}
