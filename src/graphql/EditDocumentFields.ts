/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang } from './globalTypes';

// ====================================================
// GraphQL fragment: EditDocumentFields
// ====================================================

export interface EditDocumentFields_friend {
  __typename: 'Friend';
  name: string;
  lang: Lang;
}

export interface EditDocumentFields {
  __typename: 'Document';
  id: string;
  friend: EditDocumentFields_friend;
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
