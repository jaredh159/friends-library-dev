/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang, EditionType, PrintSizeVariant } from './globalTypes';

// ====================================================
// GraphQL query operation: EditDocument
// ====================================================

export interface EditDocument_document_friend {
  __typename: 'Friend';
  name: string;
  lang: Lang;
}

export interface EditDocument_document_editions_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface EditDocument_document_editions {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  paperbackSplits: number[] | null;
  paperbackOverrideSize: PrintSizeVariant | null;
  isbn: EditDocument_document_editions_isbn | null;
  isDraft: boolean;
}

export interface EditDocument_document {
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
  friend: EditDocument_document_friend;
  editions: EditDocument_document_editions[];
}

export interface EditDocument {
  document: EditDocument_document;
}

export interface EditDocumentVariables {
  id: UUID;
}
