/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang } from './globalTypes';

// ====================================================
// GraphQL query operation: EditDocument
// ====================================================

export interface EditDocument_document_friend {
  __typename: 'Friend';
  name: string;
  lang: Lang;
}

export interface EditDocument_document {
  __typename: 'Document';
  id: string;
  friend: EditDocument_document_friend;
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
}

export interface EditDocument {
  document: EditDocument_document;
}

export interface EditDocumentVariables {
  id: UUID;
}
