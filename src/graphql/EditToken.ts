/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Scope } from './globalTypes';

// ====================================================
// GraphQL query operation: EditToken
// ====================================================

export interface EditToken_token_scopes_token {
  __typename: 'Token';
  id: string;
}

export interface EditToken_token_scopes {
  __typename: 'TokenScope';
  id: string;
  type: Scope;
  token: EditToken_token_scopes_token;
}

export interface EditToken_token {
  __typename: 'Token';
  id: string;
  value: string;
  description: string;
  createdAt: string;
  uses: number | null;
  scopes: EditToken_token_scopes[];
}

export interface EditToken {
  token: EditToken_token;
}

export interface EditTokenVariables {
  id: UUID;
}
