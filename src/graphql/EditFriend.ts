/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang, Gender, EditionType, PrintSizeVariant } from './globalTypes';

// ====================================================
// GraphQL query operation: EditFriend
// ====================================================

export interface EditFriend_friend_quotes {
  __typename: 'FriendQuote';
  id: string;
  source: string;
  text: string;
  order: number;
}

export interface EditFriend_friend_documents_friend {
  __typename: 'Friend';
  name: string;
  lang: Lang;
}

export interface EditFriend_friend_documents_editions_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface EditFriend_friend_documents_editions {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  paperbackSplits: number[] | null;
  paperbackOverrideSize: PrintSizeVariant | null;
  isbn: EditFriend_friend_documents_editions_isbn | null;
  isDraft: boolean;
}

export interface EditFriend_friend_documents {
  __typename: 'Document';
  id: string;
  altLanguageId: string | null;
  title: string;
  slug: string;
  filename: string;
  published: number | null;
  originalTitle: string | null;
  incomplete: boolean;
  description: string;
  partialDescription: string;
  featuredDescription: string | null;
  friend: EditFriend_friend_documents_friend;
  editions: EditFriend_friend_documents_editions[];
}

export interface EditFriend_friend {
  __typename: 'Friend';
  lang: Lang;
  name: string;
  slug: string;
  gender: Gender;
  born: number | null;
  died: number | null;
  description: string;
  quotes: EditFriend_friend_quotes[];
  documents: EditFriend_friend_documents[];
}

export interface EditFriend {
  friend: EditFriend_friend;
}

export interface EditFriendVariables {
  id: UUID;
}
