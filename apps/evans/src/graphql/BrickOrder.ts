/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { BrickOrderInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: BrickOrder
// ====================================================

export interface BrickOrder_result {
  __typename: 'GenericResponse';
  success: boolean;
}

export interface BrickOrder {
  result: BrickOrder_result;
}

export interface BrickOrderVariables {
  input: BrickOrderInput;
}
