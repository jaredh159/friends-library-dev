/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang } from './globalTypes';

// ====================================================
// GraphQL fragment: SelectableDocumentsFields
// ====================================================

export interface SelectableDocumentsFields_friend {
  __typename: 'Friend';
  lang: Lang;
  alphabeticalName: string;
}

export interface SelectableDocumentsFields {
  __typename: 'Document';
  id: string;
  title: string;
  friend: SelectableDocumentsFields_friend;
}
