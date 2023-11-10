import BuildClient from '@friends-library/pairql/evans-build';
import type { Document, Edition, Friend, PublishedCounts } from './types';
import { sortFriends } from './query';

type DocumentEntities = {
  document: Document;
  friend: Friend;
};

type EditionEntities = DocumentEntities & {
  edition: Edition;
};

let cachedFriends: Friend[] | null = null;
const client = BuildClient.node(process);

export async function queryFriends(): Promise<Friend[]> {
  if (cachedFriends) return cachedFriends;
  const friends = await client.getFriends();
  cachedFriends = sortFriends(friends);
  return friends;
}

export async function queryDocuments(): Promise<DocumentEntities[]> {
  const friends = await queryFriends();
  const entities: DocumentEntities[] = [];
  for (const friend of friends) {
    for (const document of friend.documents) {
      entities.push({ document, friend });
    }
  }
  return entities;
}

export async function queryEditions(): Promise<EditionEntities[]> {
  const friends = await queryFriends();
  const entities: EditionEntities[] = [];
  for (const friend of friends) {
    for (const document of friend.documents) {
      for (const edition of document.editions) {
        entities.push({ edition, document, friend });
      }
    }
  }
  return entities;
}

const publishedCounts: PublishedCounts = {
  friends: { en: -1, es: -1 },
  books: { en: -1, es: -1 },
  updatedEditions: { en: -1, es: -1 },
  audioBooks: { en: -1, es: -1 },
};

export async function queryPublishedCounts(): Promise<PublishedCounts> {
  if (publishedCounts.friends.en !== -1) {
    return publishedCounts;
  }

  const friends = await queryFriends();
  const documentEntities = await queryDocuments();
  const editionEntities = await queryEditions();

  publishedCounts.friends.en = friends.filter(
    (f) => f.lang === `en` && f.hasNonDraftDocument,
  ).length;

  publishedCounts.friends.es = friends.filter(
    (f) => f.lang === `es` && f.hasNonDraftDocument,
  ).length;

  publishedCounts.books.en = documentEntities.filter(
    (e) => e.friend.lang === `en` && e.document.hasNonDraftEdition,
  ).length;

  publishedCounts.books.es = documentEntities.filter(
    (e) => e.friend.lang === `es` && e.document.hasNonDraftEdition,
  ).length;

  publishedCounts.updatedEditions.en = editionEntities.filter(
    (e) => e.friend.lang === `en` && !e.edition.isDraft && e.edition.type === `updated`,
  ).length;

  publishedCounts.updatedEditions.es = editionEntities.filter(
    (e) => e.friend.lang === `es` && !e.edition.isDraft && e.edition.type === `updated`,
  ).length;

  publishedCounts.audioBooks.en = editionEntities.filter(
    (e) => e.friend.lang === `en` && !e.edition.isDraft && e.edition.audio,
  ).length;

  publishedCounts.audioBooks.es = editionEntities.filter(
    (e) => e.friend.lang === `es` && !e.edition.isDraft && e.edition.audio,
  ).length;

  return publishedCounts;
}

export async function queryDocumentDownloadCounts(): Promise<Record<UUID, number>> {
  const data = await client.getDocumentDownloadCounts();
  const counts: Record<UUID, number> = {};
  for (const { documentId, downloadCount } of data) {
    counts[documentId] = downloadCount;
  }
  return counts;
}
