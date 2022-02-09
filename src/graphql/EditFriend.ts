/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang, Gender, EditionType, PrintSizeVariant, TagType } from './globalTypes';

// ====================================================
// GraphQL query operation: EditFriend
// ====================================================

export interface EditFriend_friend_quotes_friend {
  __typename: 'Friend';
  id: string;
}

export interface EditFriend_friend_quotes {
  __typename: 'FriendQuote';
  id: string;
  source: string;
  text: string;
  order: number;
  friend: EditFriend_friend_quotes_friend;
}

export interface EditFriend_friend_documents_friend {
  __typename: 'Friend';
  id: string;
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

export interface EditFriend_friend_documents_tags {
  __typename: 'DocumentTag';
  id: string;
  type: TagType;
}

export interface EditFriend_friend_documents_relatedDocuments {
  __typename: 'RelatedDocument';
  id: string;
  description: string;
  documentId: string;
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
  tags: EditFriend_friend_documents_tags[];
  relatedDocuments: EditFriend_friend_documents_relatedDocuments[];
}

export interface EditFriend_friend_residences_durations_residence {
  __typename: 'FriendResidence';
  id: string;
}

export interface EditFriend_friend_residences_durations {
  __typename: 'FriendResidenceDuration';
  id: string;
  start: number;
  end: number;
  residence: EditFriend_friend_residences_durations_residence;
}

export interface EditFriend_friend_residences_friend {
  __typename: 'Friend';
  id: string;
}

export interface EditFriend_friend_residences {
  __typename: 'FriendResidence';
  id: string;
  city: string;
  region: string;
  durations: EditFriend_friend_residences_durations[];
  friend: EditFriend_friend_residences_friend;
}

export interface EditFriend_friend {
  __typename: 'Friend';
  id: string;
  lang: Lang;
  name: string;
  slug: string;
  gender: Gender;
  born: number | null;
  died: number | null;
  description: string;
  quotes: EditFriend_friend_quotes[];
  documents: EditFriend_friend_documents[];
  residences: EditFriend_friend_residences[];
}

export interface EditFriend_selectableDocuments_friend {
  __typename: 'Friend';
  lang: Lang;
  alphabeticalName: string;
}

export interface EditFriend_selectableDocuments {
  __typename: 'Document';
  id: string;
  title: string;
  friend: EditFriend_selectableDocuments_friend;
}

export interface EditFriend {
  friend: EditFriend_friend;
  selectableDocuments: EditFriend_selectableDocuments[];
}

export interface EditFriendVariables {
  id: UUID;
}
