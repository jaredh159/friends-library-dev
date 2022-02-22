/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateDocumentInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateDocument
// ====================================================

export interface UpdateDocument_document {
  __typename: 'Document';
  id: string;
}

export interface UpdateDocument {
  document: UpdateDocument_document;
}

export interface UpdateDocumentVariables {
  input: UpdateDocumentInput;
}
