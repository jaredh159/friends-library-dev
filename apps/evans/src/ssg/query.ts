/// <reference types="../../globals.d.ts" />
import type { EditionType } from '@friends-library/types';
import type { Friend } from './types';

export function sortFriends(friends: Friend[]): Friend[] {
  friends.sort((a, b) => (a.id < b.id ? -1 : 1));
  for (const friend of friends) {
    friend.relatedDocuments.sort((a, b) => (a.documentId < b.documentId ? -1 : 1));
    friend.quotes.sort(byOrder);
    friend.documents.sort(sortDocuments);

    for (const residence of friend.residences) {
      residence.durations.sort((a, b) => a.start - b.start);
    }

    friend.residences.sort((a, b) => {
      if (a.durations.length === 1 && b.durations.length === 1) {
        return a.durations[0].start < b.durations[0].start ? -1 : 1;
      } else {
        return a.city < b.city ? -1 : 1;
      }
    });

    for (const document of friend.documents) {
      document.editions.sort(editionsByType);
      document.tags.sort((a, b) => (a < b ? -1 : 1));
      document.relatedDocuments.sort((a, b) => (a.documentId < b.documentId ? -1 : 1));
      for (const edition of document.editions) {
        if (edition.audio?.isPublished === false) {
          edition.audio = undefined;
        } else if (edition.audio) {
          edition.audio.parts = edition.audio.parts.filter((part) => part.isPublished);
          edition.audio.parts.sort(byOrder);
        }
      }
    }
  }
  return friends;
}

function editionsByType<T extends { type: EditionType }>(a: T, b: T): number {
  if (a.type === `updated`) {
    return -1;
  }
  if (a.type === `modernized`) {
    return b.type === `updated` ? 1 : -1;
  }
  return 1;
}

function byOrder<T extends { order: number }>(a: T, b: T): number {
  return a.order < b.order ? -1 : 1;
}

type SortableDoc = {
  primaryEdition?: { type: EditionType };
  title: string;
};

export function sortDocuments(a: SortableDoc, b: SortableDoc): number {
  if (a.primaryEdition?.type !== b.primaryEdition?.type) {
    if (a.primaryEdition?.type === `updated`) {
      return -1;
    }
    if (a.primaryEdition?.type === `modernized`) {
      return b.primaryEdition?.type === `updated` ? 1 : -1;
    }
    return 1;
  }
  return a.title < b.title ? -1 : 1;
}
