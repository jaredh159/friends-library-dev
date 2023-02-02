/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteToken
// ====================================================

export interface DeleteToken_part {
  __typename: 'Token';
  id: string;
}

export interface DeleteToken {
  part: DeleteToken_part;
}

export interface DeleteTokenVariables {
  id: UUID;
}
