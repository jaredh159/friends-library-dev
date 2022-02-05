/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang, EditionType, PrintSizeVariant, TagType } from './globalTypes';

// ====================================================
// GraphQL fragment: EditDocumentFields
// ====================================================

export interface EditDocumentFields_friend {
  __typename: 'Friend';
  name: string;
  lang: Lang;
}

export interface EditDocumentFields_editions_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface EditDocumentFields_editions {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  paperbackSplits: number[] | null;
  paperbackOverrideSize: PrintSizeVariant | null;
  isbn: EditDocumentFields_editions_isbn | null;
  isDraft: boolean;
}

export interface EditDocumentFields_tags {
  __typename: 'DocumentTag';
  type: TagType;
}

export interface EditDocumentFields {
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
  friend: EditDocumentFields_friend;
  editions: EditDocumentFields_editions[];
  tags: EditDocumentFields_tags[];
}
