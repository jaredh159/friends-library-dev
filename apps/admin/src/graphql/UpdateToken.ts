/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateTokenInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateToken
// ====================================================

export interface UpdateToken_part {
  __typename: 'Token';
  id: string;
}

export interface UpdateToken {
  part: UpdateToken_part;
}

export interface UpdateTokenVariables {
  input: UpdateTokenInput;
}
