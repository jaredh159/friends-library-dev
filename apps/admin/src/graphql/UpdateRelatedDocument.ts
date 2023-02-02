/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateRelatedDocumentInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateRelatedDocument
// ====================================================

export interface UpdateRelatedDocument_relatedDocument {
  __typename: 'RelatedDocument';
  id: string;
}

export interface UpdateRelatedDocument {
  relatedDocument: UpdateRelatedDocument_relatedDocument;
}

export interface UpdateRelatedDocumentVariables {
  input: UpdateRelatedDocumentInput;
}
