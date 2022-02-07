import { v4 as uuid } from 'uuid';
import { EditionType, Gender, Lang } from '../graphql/globalTypes';
import {
  EditableFriendQuote,
  EditableDocument,
  EditableEdition,
  EditableFriend,
  EditableFriendResidence,
  EditableFriendResidenceDuration,
  EditableRelatedDocument,
  EditableDocumentTag,
} from '../types';

export function friend(): EditableFriend {
  return {
    __typename: `Friend`,
    lang: Lang.en,
    id: clientGeneratedId(),
    name: ``,
    slug: ``,
    born: null,
    died: null,
    gender: Gender.male,
    description: ``,
    quotes: [],
    documents: [],
    residences: [],
  };
}

export function friendQuote(existing: EditableFriendQuote[]): EditableFriendQuote {
  return {
    __typename: `FriendQuote`,
    id: clientGeneratedId(),
    source: ``,
    text: ``,
    order: Math.max(0, ...existing.map((q) => q.order)) + 10,
  };
}

export function edition(): EditableEdition {
  return {
    __typename: `Edition`,
    id: clientGeneratedId(),
    isDraft: true,
    type: EditionType.updated,
    paperbackOverrideSize: null,
    paperbackSplits: null,
    isbn: null,
  };
}

export function friendResidence(): EditableFriendResidence {
  return {
    __typename: `FriendResidence`,
    id: clientGeneratedId(),
    city: ``,
    region: `England`,
    durations: [],
  };
}

export function friendResidenceDuration(): EditableFriendResidenceDuration {
  return {
    __typename: `FriendResidenceDuration`,
    id: clientGeneratedId(),
    start: 1600,
    end: 1700,
  };
}

export function relatedDocument(documentId: UUID): EditableRelatedDocument {
  return {
    __typename: `RelatedDocument`,
    id: clientGeneratedId(),
    description: ``,
    documentId,
  };
}

export function document(friend: EditableFriend): EditableDocument {
  return {
    __typename: `Document`,
    id: clientGeneratedId(),
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
    relatedDocuments: [],
  };
}

export function documentTag(type: EditableDocumentTag['type']): EditableDocumentTag {
  return {
    __typename: `DocumentTag`,
    id: clientGeneratedId(),
    type,
  };
}

function clientGeneratedId(): string {
  return `_${uuid()}`;
}
