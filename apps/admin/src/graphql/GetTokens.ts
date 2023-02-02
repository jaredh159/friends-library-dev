/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Scope } from './globalTypes';

// ====================================================
// GraphQL query operation: GetTokens
// ====================================================

export interface GetTokens_tokens_scopes {
  __typename: 'TokenScope';
  id: string;
  type: Scope;
}

export interface GetTokens_tokens {
  __typename: 'Token';
  id: string;
  description: string;
  createdAt: string;
  uses: number | null;
  scopes: GetTokens_tokens_scopes[];
}

export interface GetTokens {
  tokens: GetTokens_tokens[];
}
