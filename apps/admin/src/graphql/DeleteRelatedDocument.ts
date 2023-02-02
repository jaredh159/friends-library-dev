/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteRelatedDocument
// ====================================================

export interface DeleteRelatedDocument_relatedDocument {
  __typename: 'RelatedDocument';
  id: string;
}

export interface DeleteRelatedDocument {
  relatedDocument: DeleteRelatedDocument_relatedDocument;
}

export interface DeleteRelatedDocumentVariables {
  id: UUID;
}
