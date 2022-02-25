/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { LogJsErrorDataInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: JsError
// ====================================================

export interface JsError_error {
  __typename: 'GenericResponse';
  success: boolean;
}

export interface JsError {
  error: JsError_error;
}

export interface JsErrorVariables {
  input: LogJsErrorDataInput;
}
