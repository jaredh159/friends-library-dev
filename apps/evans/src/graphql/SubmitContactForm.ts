/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { SubmitContactFormInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: SubmitContactForm
// ====================================================

export interface SubmitContactForm_result {
  __typename: 'GenericResponse';
  success: boolean;
}

export interface SubmitContactForm {
  result: SubmitContactForm_result;
}

export interface SubmitContactFormVariables {
  input: SubmitContactFormInput;
}
