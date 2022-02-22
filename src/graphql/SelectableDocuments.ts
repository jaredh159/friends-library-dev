/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang } from './globalTypes';

// ====================================================
// GraphQL query operation: SelectableDocuments
// ====================================================

export interface SelectableDocuments_selectableDocuments_friend {
  __typename: 'Friend';
  lang: Lang;
  alphabeticalName: string;
}

export interface SelectableDocuments_selectableDocuments {
  __typename: 'Document';
  id: string;
  title: string;
  friend: SelectableDocuments_selectableDocuments_friend;
}

export interface SelectableDocuments {
  selectableDocuments: SelectableDocuments_selectableDocuments[];
}
