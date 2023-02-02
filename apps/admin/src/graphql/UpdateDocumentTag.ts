/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateDocumentTagInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateDocumentTag
// ====================================================

export interface UpdateDocumentTag_tag {
  __typename: 'DocumentTag';
  id: string;
}

export interface UpdateDocumentTag {
  tag: UpdateDocumentTag_tag;
}

export interface UpdateDocumentTagVariables {
  input: UpdateDocumentTagInput;
}
