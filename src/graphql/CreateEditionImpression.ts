/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { CreateEditionImpressionInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: CreateEditionImpression
// ====================================================

export interface CreateEditionImpression_impression {
  __typename: 'EditionImpression';
  id: string;
}

export interface CreateEditionImpression {
  impression: CreateEditionImpression_impression;
}

export interface CreateEditionImpressionVariables {
  input: CreateEditionImpressionInput;
}
