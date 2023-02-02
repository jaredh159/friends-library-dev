/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteDocument
// ====================================================

export interface DeleteDocument_document {
  __typename: 'Document';
  id: string;
}

export interface DeleteDocument {
  document: DeleteDocument_document;
}

export interface DeleteDocumentVariables {
  id: UUID;
}
