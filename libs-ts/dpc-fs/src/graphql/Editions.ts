/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { EditionType, Lang } from './globalTypes';

// ====================================================
// GraphQL query operation: Editions
// ====================================================

export interface Editions_editions_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface Editions_editions_document_friend {
  __typename: 'Friend';
  isCompilations: boolean;
  lang: Lang;
  slug: string;
  name: string;
  alphabeticalName: string;
}

export interface Editions_editions_document {
  __typename: 'Document';
  title: string;
  originalTitle: string | null;
  published: number | null;
  description: string;
  slug: string;
  friend: Editions_editions_document_friend;
}

export interface Editions_editions {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  editor: string | null;
  directoryPath: string;
  paperbackSplits: number[] | null;
  isbn: Editions_editions_isbn | null;
  document: Editions_editions_document;
}

export interface Editions {
  editions: Editions_editions[];
}
