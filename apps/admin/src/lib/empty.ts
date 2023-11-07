import { v4 as uuid } from 'uuid';
import type { Scope as TokenScope } from '../graphql/globalTypes';
import type { EditableRelatedDocument, EditableTokenScope } from '../types';
import { type T } from '../api-client';

export function friend(): T.EditableFriend {
  return {
    lang: `en`,
    id: clientGeneratedId(),
    name: ``,
    slug: ``,
    born: undefined,
    died: undefined,
    gender: `male`,
    description: ``,
    published: undefined,
    quotes: [],
    documents: [],
    residences: [],
  };
}

export function friendQuote(friend: T.EditableFriend): T.EditableFriendQuote {
  return {
    // __typename: `FriendQuote`,
    id: clientGeneratedId(),
    source: ``,
    text: ``,
    // friend: {
    //   __typename: `Friend`,
    //   id: friend.id,
    // },
    order: Math.max(0, ...friend.quotes.map((q) => q.order)) + 1,
  };
}

export function edition(_documentId: UUID): T.EditableEdition {
  return {
    // __typename: `Edition`,
    id: clientGeneratedId(),
    isDraft: true,
    type: `updated`,
    paperbackOverrideSize: undefined,
    paperbackSplits: undefined,
    isbn: undefined,
    editor: undefined,
    audio: undefined,
    // document: {
    //   __typename: `Document`,
    //   id: documentId,
    // },
  };
}

export function audio(_editionId: UUID): T.EditableAudio {
  return {
    // __typename: `Audio`,
    id: clientGeneratedId(),
    reader: `Jessie Henderson`,
    isIncomplete: false,
    m4bSizeHq: 0,
    m4bSizeLq: 0,
    mp3ZipSizeHq: 0,
    mp3ZipSizeLq: 0,
    externalPlaylistIdHq: undefined,
    externalPlaylistIdLq: undefined,
    parts: [],
    // edition: {
    //   __typename: `Edition`,
    //   id: editionId,
    // },
  };
}

export function audioPart(audio: T.EditableAudio): T.EditableAudioPart {
  // throw new Error(`todo: Not implemented`);
  return {
    // __typename: `AudioPart`,
    id: clientGeneratedId(),
    order: Math.max(0, ...audio.parts.map((part) => part.order)) + 1,
    title: ``,
    duration: 0,
    chapters: [0],
    mp3SizeHq: 0,
    mp3SizeLq: 0,
    externalIdHq: 0,
    externalIdLq: 0,
    // audio: {
    //   // __typename: `Audio`,
    //   id: audio.id,
    // },
  };
}

export function friendResidence(): T.EditableFriendResidence {
  return {
    id: clientGeneratedId(), // todo...
    city: ``,
    region: `England`,
    durations: [],
  };
}

export function friendResidenceDuration(): T.EditableFriendResidence['durations'][number] {
  return {
    id: clientGeneratedId(),
    start: 1600,
    end: 1700,
  };
}

export function relatedDocument(
  documentId: UUID,
  parentDocumentId: UUID,
): EditableRelatedDocument {
  return {
    __typename: `RelatedDocument`,
    id: clientGeneratedId(),
    description: ``,
    document: {
      __typename: `Document`,
      id: documentId,
    },
    parentDocument: {
      __typename: `Document`,
      id: parentDocumentId,
    },
  };
}

export function document(friend: T.EditableFriend): T.EditableDocument {
  return {
    id: clientGeneratedId(),
    slug: ``,
    description: ``,
    title: ``,
    filename: ``,
    incomplete: false,
    originalTitle: ``,
    partialDescription: ``,
    featuredDescription: undefined,
    published: undefined,
    friend: {
      id: friend.id,
      lang: friend.lang,
      name: friend.name,
    },
    editions: [],
    altLanguageId: undefined,
    tags: [],
    relatedDocuments: [],
  };
}

// todo: is this pulling it's weight?
export function documentTag(
  type: T.EditableDocument['tags'][number]['type'],
): T.EditableDocument['tags'][number] {
  return {
    id: clientGeneratedId(),
    type,
  };
}

export function token(): T.EditToken.Output {
  return {
    id: clientGeneratedId(),
    createdAt: new Date().toISOString(),
    description: ``,
    value: uuid(),
    uses: undefined,
    scopes: [],
  };
}

export function tokenScope(tokenId: UUID, type: TokenScope): EditableTokenScope {
  return {
    __typename: `TokenScope`,
    id: clientGeneratedId(),
    type,
    token: {
      __typename: `Token`,
      id: tokenId,
    },
  };
}

function clientGeneratedId(): string {
  return `_${uuid()}`;
}
