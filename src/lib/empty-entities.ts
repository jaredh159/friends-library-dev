import { v4 as uuid } from 'uuid';
import { EditionType } from '../graphql/globalTypes';
import {
  EditableFriendQuote,
  EditableDocument,
  EditableEdition,
  EditableFriend,
} from '../types';

export function friendQuote(existing: EditableFriendQuote[]): EditableFriendQuote {
  return {
    __typename: `FriendQuote`,
    id: uuid(),
    source: ``,
    text: ``,
    order: Math.max(0, ...existing.map((q) => q.order)) + 10,
  };
}

export function edition(): EditableEdition {
  return {
    __typename: `Edition`,
    id: uuid(),
    isDraft: true,
    type: EditionType.updated,
    paperbackOverrideSize: null,
    paperbackSplits: null,
    isbn: null,
  };
}

export function document(friend: EditableFriend): EditableDocument {
  return {
    __typename: `Document`,
    id: uuid(),
    slug: ``,
    description: ``,
    title: ``,
    filename: ``,
    incomplete: false,
    originalTitle: ``,
    partialDescription: ``,
    featuredDescription: null,
    published: null,
    friend: {
      __typename: `Friend`,
      lang: friend.lang,
      name: friend.name,
    },
    editions: [],
    altLanguageId: null,
    tags: [],
  };
}
