/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateEditionInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateEdition
// ====================================================

export interface UpdateEdition_edition {
  __typename: 'Edition';
  id: string;
}

export interface UpdateEdition {
  edition: UpdateEdition_edition;
}

export interface UpdateEditionVariables {
  input: UpdateEditionInput;
}
