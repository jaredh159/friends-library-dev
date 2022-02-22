/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang } from './globalTypes';

// ====================================================
// GraphQL query operation: GetDocuments
// ====================================================

export interface GetDocuments_documents_friend {
  __typename: 'Friend';
  name: string;
  alphabeticalName: string;
  lang: Lang;
}

export interface GetDocuments_documents {
  __typename: 'Document';
  id: string;
  title: string;
  friend: GetDocuments_documents_friend;
}

export interface GetDocuments {
  documents: GetDocuments_documents[];
}
