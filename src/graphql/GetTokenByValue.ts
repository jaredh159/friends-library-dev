/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetTokenByValue
// ====================================================

export interface GetTokenByValue_token {
  __typename: 'Token';
  id: string;
}

export interface GetTokenByValue {
  token: GetTokenByValue_token;
}

export interface GetTokenByValueVariables {
  value: UUID;
}
