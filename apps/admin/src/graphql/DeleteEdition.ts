/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteEdition
// ====================================================

export interface DeleteEdition_edition {
  __typename: 'Edition';
  id: string;
}

export interface DeleteEdition {
  edition: DeleteEdition_edition;
}

export interface DeleteEditionVariables {
  id: UUID;
}
