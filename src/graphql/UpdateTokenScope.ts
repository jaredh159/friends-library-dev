/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateTokenScopeInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateTokenScope
// ====================================================

export interface UpdateTokenScope_part {
  __typename: 'TokenScope';
  id: string;
}

export interface UpdateTokenScope {
  part: UpdateTokenScope_part;
}

export interface UpdateTokenScopeVariables {
  input: UpdateTokenScopeInput;
}
