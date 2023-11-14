import path from 'path';
import type { GatsbyNode, CreatePagesArgs } from 'gatsby';
import type { Document } from './types';
import { documentUrl, friendUrl } from '../lib/url';
import { LANG } from '../env';
import * as api from './api';

const FriendPage = path.resolve(`./src/templates/FriendPage.tsx`);
const DocumentPage = path.resolve(`./src/templates/DocumentPage.tsx`);

const createPagesStatefully: GatsbyNode['createPagesStatefully'] = async ({
  actions: { createPage },
}: CreatePagesArgs) => {
  (await api.queryFriends())
    .filter((f) => f.lang === LANG)
    .filter((f) => f.hasNonDraftDocument)
    .forEach((friend) => {
      createPage({
        path: friend.isCompilations ? friend.slug : friendUrl(friend),
        component: FriendPage,
        context: {
          slug: friend.slug,
          relatedDocumentIds: friend.relatedDocuments.map((rd) => rd.documentId),
        },
      });

      friend.documents
        .filter((d) => d.hasNonDraftEdition)
        .forEach((document: Document) => {
          createPage({
            path: documentUrl(document, friend),
            component: DocumentPage,
            context: {
              friendSlug: friend.slug,
              documentSlug: document.slug,
            },
          });
        });
    });
};

export default createPagesStatefully;
